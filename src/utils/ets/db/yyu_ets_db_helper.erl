%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(yyu_ets_db_helper).
-author("yinye").
-include("yyu_comm_atoms.hrl").
-include("yyu_ets_db.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% API functions defined
-export([init/1,init_multi_gen_write/1]).
-export([put_edata/2, put_edata/3, remove_edata/2,get_edata/2,
  get_all_edata_list/1,get_all_key_ver_list/1,get_total_count/1]).
-export([get_ver/2, put_ver/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 一般使用这个就可以了，单进程写，多进程读，针对写少读多的情况。
init({DataTbName,VerTbName}) ->
  yyu_ets_cache_dao:init_single_gen_write(DataTbName),

  %% 对应数据在数据库中的版本号，通过该版本号判断是否需要入库
  yyu_ets_cache_dao:init_single_gen_write(VerTbName),
  ?OK.

%% 多进程写，而且存储的数据size都比较小，只做写并发，读不并发
init_multi_gen_write({DataTbName,VerTbName}) ->
  yyu_ets_cache_dao:init_multi_gen_write(DataTbName),

  %% 对应数据在数据库中的版本号，通过该版本号判断是否需要入库
  yyu_ets_cache_dao:init_multi_gen_write(VerTbName),
  ?OK.


%% 第一次put的时候要同步版本号
put_edata({DataTbName,VerTbName},NewData)->
  Key = yyu_ets_db_edata:get_key(NewData),
  Ver = yyu_ets_db_edata:get_ver(NewData),
  yyu_ets_cache_dao:put_data(DataTbName,Key,NewData),
  put_ver(VerTbName,Key,Ver),
  ?OK.

%% 有老数据的时候不能同步版本号，版本号是在入库db，持久化之后才更新，确保和db的版本保持一致
put_edata({DataTbName,_VerTbName},OldData,NewData)->
  Key = yyu_ets_db_edata:get_key(NewData),
  OldVer = yyu_ets_db_edata:get_ver(OldData),
  NewVer = yyu_ets_db_edata:get_ver(NewData),
  case NewVer > OldVer of
    ?TRUE ->
      yyu_ets_cache_dao:put_data(DataTbName,Key,NewData),
      ?OK;
    ?FALSE ->
      {error, "NewData ver is less than OldData"}
  end.

remove_edata({DataTbName,VerTbName},Key)->
  yyu_ets_cache_dao:remove(DataTbName,Key),
  yyu_ets_cache_dao:remove(VerTbName,Key),
  ?OK.

get_edata(DataTbName,Key)->
  yyu_ets_cache_dao:get_data(DataTbName,Key).

get_all_edata_list(DataTbName)->
  AllList = yyu_ets_cache_dao:get_all_valueList(DataTbName),
  AllList.

get_all_key_ver_list(DataTbName)->
  Q = ets:fun2ms(fun({_Key,#yyu_ets_db_edata{key=Key,ver=Ver}}) -> {Key,Ver} end),
  KeyVerList = yyu_ets_cache_dao:select_all_by_Q(DataTbName,Q),
  KeyVerList.

get_total_count(DataTbName)->
  yyu_ets_cache_dao:get_total_count(DataTbName).



get_ver(VerTbName,Key)->
  case yyu_ets_cache_dao:get_data(VerTbName,Key) of
    ?NOT_SET -> -1;
    Value -> Value
  end.
put_ver(VerTbName,Key,Ver)->
  yyu_ets_cache_dao:put_data(VerTbName,Key,Ver),
  ?OK.



