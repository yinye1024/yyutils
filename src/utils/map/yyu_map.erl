%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_map).
-author("yinye").
-include("yyu_comm_atoms.hrl").
-include("yyu_comm.hrl").

%% API functions defined
-export([new_map/0,put_value/3,get_value/2,get_value/3, get_value_list/2,remove/2,remove_all/2,delete/2]).
-export([is_empty/1,has_key/2,size_of/1,all_keys/1,all_values/1]).
-export([to_kv_list/1,from_kv_list/1,for_each/3,for_each/2,copy/2,copy/3,merge/2]).
-export([map/2,filter/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_map() ->
  maps:new().

put_value(Key,Value,Map)->
  maps:put(Key,Value,Map).

get_value(Key,Map)->
  case maps:find(Key,Map) of
    error ->
      ?NOT_SET;
    {?OK,Value}->
      Value
  end.
get_value(Key,DefaultValue,Map)->
  case maps:find(Key,Map) of
    error ->
      DefaultValue;
    {?OK,Value}->
      Value
  end.
get_value_list(KeyList,Map)->
  priv_get_value_list(KeyList,Map,[]).
priv_get_value_list([Key|Less],Map,AccList)->
  AccList_1 =
  case yyu_map:get_value(Key,Map) of
    ?NOT_SET -> AccList;
    Value ->
      [Value|AccList]
  end,
  priv_get_value_list(Less,Map,AccList_1);
priv_get_value_list([],_Map,AccList)->
  AccList.


remove(Key,Map)->
  NewMap = maps:remove(Key,Map),
  NewMap.
remove_all([Key|Less],Map)->
  NewMap = maps:remove(Key,Map),
  remove_all(Less,NewMap);
remove_all([],Map)->
  Map.

delete(Key,Map)->
  case maps:take(Key,Map) of
    error->
      {?NOT_FOUND};
    {Value,NewMap}->
      {?OK,Value,NewMap}
  end.

is_empty(Map)->
  Map == #{}.

has_key(Key,Map)->
  maps:is_key(Key,Map).

size_of(Map)->
  maps:size(Map).

all_keys(Map)->
  maps:keys(Map).
all_values(Map)->
  maps:values(Map).

to_kv_list(Map)->
  maps:to_list(Map).
from_kv_list(KvList)->
  maps:from_list(KvList).

for_each(Fun,Map)->
  for_each(Fun,?NOT_SET,Map).

for_each(Fun,Acc,Map)->
  maps:fold(Fun,Acc,Map).

copy(FromMap,ToMap)->
  copy(FromMap,ToMap,[]).
copy(FromMap,ToMap,ExcludeKeyList)->
  KvList = to_kv_list(FromMap),
  priv_copy(KvList,ExcludeKeyList,ToMap).
priv_copy([{Key,Value}|Less],ExcludeKeyList,AccMap)->
  NewAccMap =
  case yyu_map:has_key(Key,AccMap) andalso not yyu_list:contains(Key,ExcludeKeyList) of
    ?TRUE ->
      put_value(Key,Value,AccMap);
    ?FALSE ->
      AccMap
  end,
  priv_copy(Less,ExcludeKeyList,NewAccMap);
priv_copy([],_ExcludeKeyList,AccMap)->
  AccMap.

merge(MapA,MapB)->
  maps:merge(MapA,MapB).

%% Fun(K,V)-> V_1 = do_something_to(V),V_1 end.
%% DataMap = yyu_map:map(PredFun,ItemMap),
map(Fun,Map)->
  maps:map(Fun,Map).
%% FilterFun = fun(DataId,_Data) -> yyu_list:contains(DataId,DataIdList) end,
%% DataMap = yyu_map:filter(FilterFun,ItemMap),
filter(PredFun,Map)->
  maps:filter(PredFun,Map).
