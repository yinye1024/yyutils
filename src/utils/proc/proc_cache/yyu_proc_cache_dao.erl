%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_cache_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1,put_all/2,put_data/3,delete_data/2,remove_data/2,clean_data/1]).
-export([is_inited/1,get_all_kvlist/1,get_all_map/1,get_data/2,get_data/3]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(ProcId) when is_atom(ProcId)->
  DataMap = yyu_map:new_map(),
  init(ProcId,DataMap),
  ?OK.
init(ProcId,DataMap) when is_atom(ProcId) andalso is_map(DataMap)->
  put(ProcId,DataMap),
  ?OK.

is_inited(ProcId)->
  get(ProcId) =/= ?UNDEFINED.

get_data(ProcId,Key)->
  DataMap = get(ProcId),
  yyu_map:get_value(Key,DataMap).

get_data(ProcId,Key,Default)->
  DataMap = get(ProcId),
  yyu_map:get_value(Key,DataMap,Default).

get_all_map(ProcId)->
  DataMap = get(ProcId),
  DataMap.

get_all_kvlist(ProcId)->
  DataMap = get(ProcId),
  yyu_map:to_kv_list(DataMap).

put_data(ProcId,Key, Data) ->
  DataMap = get(ProcId),
  NewDataMap = yyu_map:put_value(Key, Data,DataMap),
  put(ProcId,NewDataMap),
  ?OK.

put_all(ProcId,DataMap) when is_map(DataMap) ->
  put(ProcId,DataMap),
  ?OK.

%% @doc 返回 {not_found} or {ok,Value}
delete_data(ProcId,Key) ->
  DataMap = get(ProcId),
  case yyu_map:delete(Key,DataMap) of
    {?NOT_FOUND} -> {?NOT_FOUND};
    {?OK,Value,NewDataMap} ->
      put(ProcId,NewDataMap),
      {?OK,Value}
  end.

%% @doc return ok always
remove_data(ProcId,Key)->
  delete_data(ProcId,Key),
  ?OK.

clean_data(ProcId)->
  DataMap = yyu_map:new_map(),
  put(ProcId,DataMap),
  ?OK.
