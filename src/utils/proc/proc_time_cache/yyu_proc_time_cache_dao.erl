%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_time_cache_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1,is_inited/1,clean_all/1]).
-export([get_data/2,put_data/4,check_and_clean_cache/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(ProcId) when is_atom(ProcId)->
  DataMap = yyu_map:new_map(),
  put(ProcId,DataMap),
  ?OK.

is_inited(ProcId)->
  get(ProcId) =/= ?UNDEFINED.

get_data(ProcId,Key)->
  DataMap = get(ProcId),
  Data =
  case yyu_map:get_value(Key,DataMap) of
    ?NOT_SET ->?NOT_SET;
    CacheItem ->
      case yyu_proc_time_cache_item:is_expired(CacheItem) of
        ?FALSE -> yyu_proc_time_cache_item:get_data(CacheItem);
        ?TRUE-> ?NOT_SET
      end
  end,
  Data.


put_data(ProcId,Key, Data,CacheTimeSec) ->
  DataMap = get(ProcId),
  ExpiredTime = yyu_time:now_seconds()+CacheTimeSec,
  CacheItem = yyu_proc_time_cache_item:new(Key,DataMap,ExpiredTime),
  NewDataMap = yyu_map:put_value(Key, CacheItem,DataMap),
  put(ProcId,NewDataMap),
  ?OK.

check_and_clean_cache(ProcId)->
  DataMap = get(ProcId),
  AllList = yyu_map:all_values(DataMap),
  NewDataMap = priv_check_and_clean_cache(AllList,DataMap),
  put(ProcId,NewDataMap).
priv_check_and_clean_cache([CacheItem|Less], AccDataMap)->
  AccDataMap_1 =
  case yyu_proc_time_cache_item:is_expired(CacheItem) of
    ?TRUE ->
      yyu_map:remove(yyu_proc_time_cache_item:get_key(CacheItem), AccDataMap);
    ?FALSE ->
      AccDataMap
  end,
  priv_check_and_clean_cache(Less, AccDataMap_1);
priv_check_and_clean_cache([], AccDataMap)->
  AccDataMap.

clean_all(ProcId)->
  DataMap = yyu_map:new_map(),
  put(ProcId,DataMap),
  ?OK.
