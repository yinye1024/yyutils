%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(yyu_ets_db).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1,get_ver_TbName/1]).
-export([get_data/2,get_all_dataList/1,get_need_update_keyList/3,get_total_count/1]).
-export([put_data/3,remove_data/2]).
-export([update_to_db/2,update_to_db/1]).
-export([load_all_from_dets/2,save_all_to_dets/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({DataTbName,VerTbName})->
  yyu_ets_db_helper:init({DataTbName,VerTbName}),
  ?OK.
get_ver_TbName(DataTbName)->
  Name = yyu_misc:list_to_atom(yyu_misc:to_list(DataTbName)++"_ver"),
  Name.


get_data(DataTbName,Key)->
  Data =
  case yyu_ets_db_helper:get_edata(DataTbName,Key) of
    ?NOT_SET ->
      ?NOT_SET;
    Edata ->
      yyu_ets_db_edata:get_data(Edata)
  end,
  Data.

get_all_dataList(DataTbName)->
  EdataList = yyu_ets_db_helper:get_all_edata_list(DataTbName),
  priv_get_all_dataList(EdataList,[]).
priv_get_all_dataList([Pdata|Less],AccList)->
  priv_get_all_dataList(Less,[yyu_ets_db_edata:get_data(Pdata)|AccList]);
priv_get_all_dataList([],AccList)->
  AccList.


get_need_update_keyList([Key|Less],{DataTbName,VerTbName},AccList)->
  NewAccList =
  case yyu_ets_db_helper:get_edata(DataTbName,Key) of
    ?NOT_SET ->
      AccList;
    Edata ->
      DbVer = yyu_ets_db_helper:get_ver(VerTbName,Key),
      case DbVer < yyu_ets_db_edata:get_ver(Edata) of
        ?TRUE ->
          [Key|AccList];
        ?FALSE ->
          AccList
      end
  end,
  get_need_update_keyList(Less,{DataTbName,VerTbName},NewAccList);
get_need_update_keyList([],{_DataTbName,_VerTbName},AccList)->
  AccList.

get_total_count(DataTbName)->
  TotalCount = yyu_ets_db_helper:get_total_count(DataTbName),
  TotalCount.


put_data({DataTbName,VerTbName},{Key,Data,Ver},UpdateFun)->
  NewData = yyu_ets_db_edata:new({Key,Data,Ver},UpdateFun),
  case yyu_ets_db_helper:get_edata(DataTbName,Key) of
    ?NOT_SET ->
      yyu_ets_db_helper:put_edata({DataTbName,VerTbName},NewData),
      ?OK;
    OldData ->
      yyu_ets_db_helper:put_edata({DataTbName,VerTbName},OldData,NewData),
      ?OK
  end,
  ?OK.

%% 这里业务层要对应的调用数据库的删除操作，尽量少做删除的操作，可以用加删除标记的方式代替物理删除
remove_data({DataTbName,VerTbName},Key)->
  yyu_ets_db_helper:remove_edata({DataTbName,VerTbName},Key),
  ?OK.

%% 业务层标记哪些key变化，然后用这个方法根据 KeyList 进行比较和入库操作
update_to_db({DataTbName,VerTbName},KeyList)->
  yyu_ets_db_updater:update({DataTbName,VerTbName},KeyList),
  ?OK.

%% ets全部数据入库，会做内存全拷贝到当前业务进程。慎用，要考虑数据量的大小
update_to_db({DataTbName,VerTbName})->
  yyu_ets_db_updater:update({DataTbName,VerTbName}),
  ?OK.




%% ========================= dets 加速 开始 ===========================================================
load_all_from_dets({DataTbName,DataFilePath},{VerTbName,VerFilePath})->
  priv_load_all_from_dets(DataTbName,DataFilePath),
  priv_load_all_from_dets(VerTbName,VerFilePath),
  ?OK.
priv_load_all_from_dets(EtsTbName,AbsFilePath)->
  yyu_dets_dao:init(EtsTbName,AbsFilePath),
  yyu_dets_dao:to_ets(EtsTbName,EtsTbName),
  yyu_dets_dao:close(EtsTbName),
  ?OK.

save_all_to_dets({DataTbName,DataFilePath},{VerTbName,VerFilePath})->
  yyu_file:ensure_dir(DataFilePath),
  yyu_file:ensure_dir(VerFilePath),

  priv_save_all_to_dets(DataTbName,DataFilePath),
  priv_save_all_to_dets(VerTbName,VerFilePath),
  ?OK.
priv_save_all_to_dets(EtsTbName,AbsFilePath)->
  yyu_dets_dao:init(EtsTbName,AbsFilePath,?FALSE),
  yyu_dets_dao:from_ets(EtsTbName,EtsTbName),
  yyu_dets_dao:close(EtsTbName),
  ?OK.


%% ========================= dets 加速 结束 ===========================================================
