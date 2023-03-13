%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_lru_cache_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

-define(DataKey,1).

%% API functions defined
-export([proc_init/2,is_inited/1]).
-export([get_lru_data/2,put_lru_data/3]).
-export([check_lru/1, put_back_expired_data/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(ProcId,ExpiredInterval) when is_atom(ProcId)->
  yyu_proc_cache_dao:init(ProcId),
  priv_put_adm(ProcId,yyu_proc_lru_item:new(?DataKey,ExpiredInterval)),
  ?OK.

is_inited(ProcId)->
  yyu_proc_cache_dao:is_inited(ProcId).

get_lru_data(ProcId,DataId)->
  LruItem = priv_get_adm(ProcId),
  Data =
  case yyu_proc_lru_item:get_data(DataId,LruItem) of
    ?NOT_SET->
      ?NOT_SET;
    {DataTmp,LruItem_1}->
      priv_put_adm(ProcId,LruItem_1),
      DataTmp
  end,
  Data.

put_lru_data(ProcId,DataId,Data)->
  LruItem = priv_get_adm(ProcId),
  LruItem_1 = yyu_proc_lru_item:put_data(DataId,Data,LruItem),
  priv_put_adm(ProcId,LruItem_1),
  ?OK.

check_lru(ProcId)->
  LruItem = priv_get_adm(ProcId),
  {ExpiredDataMap,LruItem_1} = yyu_proc_lru_item:check_lru(LruItem),
  priv_put_adm(ProcId,LruItem_1),
  ExpiredDataMap.

put_back_expired_data(ProcId,ExpiredDataMap)->
  LruItem = priv_get_adm(ProcId),
  LruItem_1 = yyu_proc_lru_item:put_back_expired_data(yyu_map:to_kv_list(ExpiredDataMap),LruItem),
  priv_put_adm(ProcId,LruItem_1),
  ?OK.



%% 从 check_lru 获得 {ExpiredDataMapTmp,LruItem_1}
%% ExpiredDataMapTmp 成功操作完，才更新LruItem_1，否则不更新，下次重复操作
priv_put_adm(ProcId,LruItem)->
  yyu_proc_cache_dao:put_data(ProcId,?DataKey,LruItem),
  ?OK.

priv_get_adm(ProcId)->
  LruItem = yyu_proc_cache_dao:get_data(ProcId,?DataKey),
  LruItem.