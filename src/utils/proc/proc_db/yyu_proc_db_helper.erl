%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(yyu_proc_db_helper).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1]).
-export([put_pdata/2, put_pdata/3,remove_pdata/2,get_pdata/2,get_all_pdata_list/1,get_all_kv_list/1]).
-export([get_ver/2, put_ver/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({DataMapKey,VerMapKey})->
  DataMap = yyu_map:new_map(),
  %% 对应数据在数据库中的版本号，通过该版本号判断是否需要保存到数据库中
  VerMap = yyu_map:new_map(),
  put(DataMapKey,DataMap),
  put(VerMapKey,VerMap),
  ?OK.

%% 第一次put的时候要同步版本号
put_pdata({DataMapKey,VerMapKey},NewData)->
  Key = yyu_proc_db_item:get_key(NewData),
  Ver = yyu_proc_db_item:get_ver(NewData),
  priv_put_pdata(DataMapKey,Key,NewData),
  put_ver(VerMapKey,Key,Ver),
  ?OK.

%% 有老数据的时候不能同步版本号，版本号是在入库db，持久化之后才更新，确保和db的版本保持一致
put_pdata({DataMapKey,_VerMapKey},OldData,NewData)->
  Key = yyu_proc_db_item:get_key(NewData),
  OldVer = yyu_proc_db_item:get_ver(OldData),
  NewVer = yyu_proc_db_item:get_ver(NewData),
  case NewVer > OldVer of
    ?TRUE ->
      priv_put_pdata(DataMapKey,Key,NewData),
      ?OK;
    ?FALSE ->
      {error, "NewData ver is less than OldData"}
  end.

remove_pdata({DataMapKey,VerMapKey},Key)->
  priv_remove_pdata(DataMapKey,Key),
  priv_remove_ver(VerMapKey,Key),
  ?OK.

get_all_pdata_list(DataMapKey)->
  DataMap = get(DataMapKey),
  yyu_map:all_values(DataMap).

get_all_kv_list(DataMapKey)->
  DataMap = get(DataMapKey),
  yyu_map:to_kv_list(DataMap).





get_pdata(DataMapKey,Key)->
  DataMap = get(DataMapKey),
  yyu_map:get_value(Key,DataMap).

priv_put_pdata(DataMapKey,Key,Pdata)->
  DataMap = get(DataMapKey),
  NewDataMap = yyu_map:put_value(Key,Pdata,DataMap),
  put(DataMapKey,NewDataMap),
  ?OK.
priv_remove_pdata(DataMapKey,Key)->
  DataMap = get(DataMapKey),
  NewDataMap = yyu_map:remove(Key,DataMap),
  put(DataMapKey,NewDataMap),
  ?OK.

get_ver(VerMapKey,Key)->
  DataMap = get(VerMapKey),
  case yyu_map:get_value(Key,DataMap) of
    ?NOT_SET -> -1;
    Value -> Value
  end.
put_ver(VerMapKey,Key,Ver)->
  VerMap = get(VerMapKey),
  NewVerMap = yyu_map:put_value(Key,Ver, VerMap),
  put(VerMapKey, NewVerMap),
  ?OK.
priv_remove_ver(VerMapKey,Key)->
  VerMap = get(VerMapKey),
  NewVerMap = yyu_map:remove(Key,VerMap),
  put(VerMapKey, NewVerMap),
  ?OK.


