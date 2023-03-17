%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(yyu_proc_db_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1]).
-export([get_data/2,get_all_dataList/1,put_data/3,remove_data/2]).
-export([is_data_dirty/2,update_to_db/1,update_to_db/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({DataMapKey,VerMapKey})->
  yyu_proc_db_helper:init({DataMapKey,VerMapKey}),
  ?OK.

get_data(DataMapKey,Key)->
  Data =
  case yyu_proc_db_helper:get_pdata(DataMapKey,Key) of
    ?NOT_SET ->
      ?NOT_SET;
    Pdata ->
      yyu_proc_db_item:get_data(Pdata)
  end,
  Data.
%% 当前数据是否被更新，是否需要更新到db
is_data_dirty({DataMapKey,VerMapKey},Key)->
  IsNeedSave2Db =
  case yyu_proc_db_helper:get_pdata(DataMapKey,Key) of
    ?NOT_SET ->?FALSE;
    PData ->
      yyu_proc_db_item:get_ver(PData) > yyu_proc_db_helper:get_ver(Key,VerMapKey)
  end,
  IsNeedSave2Db.

get_all_dataList(DataMapKey)->
  PdataList = yyu_proc_db_helper:get_all_pdata_list(DataMapKey),
  priv_get_all_dataList(PdataList,[]).
priv_get_all_dataList([Pdata|Less],AccList)->
  priv_get_all_dataList(Less,[yyu_proc_db_item:get_data(Pdata)|AccList]);
priv_get_all_dataList([],AccList)->
  AccList.


put_data({DataMapKey,VerMapKey},{Key,Data,Ver},UpdateFun)->
  NewData = yyu_proc_db_item:new({Key,Data,Ver},UpdateFun),
  case yyu_proc_db_helper:get_pdata(DataMapKey,Key) of
    ?NOT_SET ->
      yyu_proc_db_helper:put_pdata({DataMapKey,VerMapKey},NewData),
      ?OK;
    OldData ->
      yyu_proc_db_helper:put_pdata({DataMapKey,VerMapKey},OldData,NewData),
      ?OK
  end,
  ?OK.


remove_data({DataMapKey,VerMapKey},Key)->
  yyu_proc_db_helper:remove_pdata({DataMapKey,VerMapKey},Key),
  ?OK.

update_to_db({DataMapKey,VerMapKey})->
  yyu_proc_db_updater:update({DataMapKey,VerMapKey}),
  ?OK.

update_to_db(Key,{DataMapKey,VerMapKey})->
  yyu_proc_db_updater:update_key(Key,{DataMapKey,VerMapKey}),
  ?OK.
