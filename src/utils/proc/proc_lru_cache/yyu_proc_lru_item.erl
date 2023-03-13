%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_lru_item).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([new/2,get_id/1]).
-export([get_data/2,put_data/3]).
-export([check_lru/1, put_back_expired_data/2]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
new(DataKey,ExpiredInterval)->
  #{
    id => DataKey,
    expired_interval =>  ExpiredInterval,
    cur_id_map => yyu_map:new_map(),
    expired_id_map => yyu_map:new_map(),
    expired_time => yyu_time:now_seconds()+ExpiredInterval,
    data_map => yyu_map:new_map()
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

check_lru(ItemMap)->
  ExpiredTime = priv_get_expired_time(ItemMap),
  Now = yyu_time:now_seconds(),
  CheckResult =
  case ExpiredTime < Now of
    ?TRUE ->
      CurIdMap = priv_get_cur_id_map(ItemMap),
      ExpiredIdMap = priv_get_expired_id_map(ItemMap),
      ItemMap_1 = priv_set_cur_id_map(yyu_map:new_map(),ItemMap),
      ItemMap_2 = priv_set_expired_id_map(CurIdMap,ItemMap_1),

      ExpiredDataMap = priv_get_data_map(yyu_map:all_keys(ExpiredIdMap),ItemMap_2),
      AliveDataMap = priv_get_data_map(yyu_map:all_keys(CurIdMap),ItemMap_2),
      ItemMap_3 = priv_set_data_map(AliveDataMap,ItemMap_2),

      ItemMap_4 = priv_update_expired_time(ItemMap_3),
      {ExpiredDataMap,ItemMap_4};
    ?FALSE ->
      ?OK
  end,
  CheckResult.
priv_get_data_map(DataIdList,ItemMap)->
  PredFun = fun(DataId,_Data) -> yyu_list:contains(DataId,DataIdList) end,
  DataMap = yyu_map:filter(PredFun,ItemMap),
  DataMap.

get_data(DataId,ItemMap)->
  DataMap = priv_get_data_map(ItemMap),
  case yyu_map:get_value(DataId,DataMap) of
    ?NOT_SET -> ?NOT_SET;
    Data ->{Data,priv_refresh_dataId(DataId,ItemMap)}
  end.
put_data(DataId,Data,ItemMap)->
  DataMap = priv_get_data_map(ItemMap),
  DataMap_1 = yyu_map:put_value(DataId,Data,DataMap),
  ItemMap_1 = priv_set_data_map(DataMap_1,ItemMap),
  ItemMap_2 = priv_refresh_dataId(DataId,ItemMap_1),
  ItemMap_2.
priv_refresh_dataId(DataId,ItemMap)->
  CurIdMap = priv_get_cur_id_map(ItemMap),
  CurIdMap_1 = yyu_map:put_value(DataId,1,CurIdMap),

  ExpiredIdMap = priv_get_expired_id_map(ItemMap),
  ExpiredIdMap_1 = yyu_map:remove(DataId,ExpiredIdMap),

  ItemMap_1 =priv_set_cur_id_map(CurIdMap_1,ItemMap),
  ItemMap_2 =priv_set_expired_id_map(ExpiredIdMap_1,ItemMap_1),
  ItemMap_2.

%% 这一轮的过期数据，但又暂时不能删除，放回去，等待下一轮过期处理
put_back_expired_data([{DataId,Data}|Less], AccItemMap)->
  AccItemMap_1 = priv_put_expired_data(DataId,Data, AccItemMap),
  put_back_expired_data(Less, AccItemMap_1);
put_back_expired_data([], AccItemMap)->
  AccItemMap.
priv_put_expired_data(DataId,Data,ItemMap)->
  DataMap = priv_get_data_map(ItemMap),
  DataMap_1 = yyu_map:put_value(DataId,Data,DataMap),
  ItemMap_1 = priv_set_data_map(DataMap_1,ItemMap),
  ItemMap_2 = priv_put_expired__dataId(DataId,ItemMap_1),
  ItemMap_2.
priv_put_expired__dataId(DataId,ItemMap)->
  ExpiredIdMap = priv_get_expired_id_map(ItemMap),
  ExpiredIdMap_1 = yyu_map:put_value(DataId,1,ExpiredIdMap),
  ItemMap_1 =priv_set_expired_id_map(ExpiredIdMap_1,ItemMap),
  ItemMap_1.

priv_get_cur_id_map(ItemMap) ->
  yyu_map:get_value(cur_id_map, ItemMap).

priv_set_cur_id_map(Value, ItemMap) ->
  yyu_map:put_value(cur_id_map, Value, ItemMap).

priv_get_expired_id_map(ItemMap) ->
  yyu_map:get_value(expired_id_map, ItemMap).

priv_set_expired_id_map(Value, ItemMap) ->
  yyu_map:put_value(expired_id_map, Value, ItemMap).

priv_update_expired_time(ItemMap) ->
  priv_set_expired_time(yyu_time:now_seconds()+priv_get_expired_interval(ItemMap), ItemMap).
priv_get_expired_time(ItemMap) ->
  yyu_map:get_value(expired_time, ItemMap).

priv_set_expired_time(Value, ItemMap) ->
  yyu_map:put_value(expired_time, Value, ItemMap).
priv_get_data_map(ItemMap) ->
  yyu_map:get_value(data_map, ItemMap).
priv_get_expired_interval(ItemMap) ->
  yyu_map:get_value(expired_interval, ItemMap).

priv_set_data_map(Value, ItemMap) ->
  yyu_map:put_value(data_map, Value, ItemMap).

