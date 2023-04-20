%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_list).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([get_first_item/1,get_last_item/1,get_item_by_index/2,get_tuple_by_key/2,get_tuple_by_key/3,get_max/1,get_min/1,reverse/1,key_sort/2]).
-export([contains/2,is_empty/1,size_of/1]).
-export([add_if_not_exist/2,append_if_not_exist/2,remove/2,remove_duplicate/1]).
-export([foreach/2,filter/2,filter_one/2,map/2]).
-export([sublist/2,sublist/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_first_item([Hd|_Less])->
  Hd;
get_first_item([])->
  ?NOT_SET.

get_last_item([])->
  ?NOT_SET;
get_last_item(List)->
  lists:last(List).

get_item_by_index(Index,List)->
  priv_get_item_by_index(List,Index,1).
priv_get_item_by_index([Hd|Less],Index,Count)->
  case Index of
    Count -> Hd;
    _->
      priv_get_item_by_index(Less,Index,Count+1)
  end;
priv_get_item_by_index([],_Index,_Count)->
  ?NOT_SET.

get_tuple_by_key(Key,TupleList)->
  get_tuple_by_key(Key,1,TupleList).

get_tuple_by_key(Key, KeyIndex,TupleList)->
  case lists:keyfind(Key, KeyIndex,TupleList) of
    ?FALSE ->
      ?NOT_SET;
    Value ->
      Value
  end.

reverse(List)->
  lists:reverse(List).

key_sort(KeyIndex,List)->
  lists:keysort(KeyIndex,List).

get_max([])->
  ?NOT_SET;
get_max(List)->
  lists:max(List).

get_min([])->
  ?NOT_SET;
get_min(List)->
  lists:min(List).

contains(Item,List)->
  lists:member(Item,List).
size_of(List)->
  erlang:length(List).
is_empty(List)->
  List == [].

sublist(Length,List)->
  sublist(1,Length,List).

%% 从1开始
sublist(Start,Length,List) when Start > 0 ->
  lists:sublist(List, Start, Length).

append_if_not_exist(Item,List)->
  NewList =
  case contains(Item,List) of
    ?TRUE ->
      List;
    ?FALSE ->
      lists:append(List,[Item])
  end,
  NewList.
add_if_not_exist(Item,List)->
  NewList =
  case contains(Item,List) of
    ?TRUE ->
      List;
    ?FALSE ->
      [Item|List]
  end,
  NewList.

remove(Item,List)->
  lists:delete(Item,List).

remove_duplicate(List)->
  priv_remove_duplicate(List,[]).
priv_remove_duplicate([Item|Less],AccList)->
  NewAccList =
  case contains(Item,AccList) of
    ?TRUE -> AccList;
    ?FALSE ->[Item|AccList]
  end,
  priv_remove_duplicate(Less,NewAccList);
priv_remove_duplicate([],AccList)->
  AccList.

%% fun(X) -> X rem 2 == 0,?Ok end
foreach(Fun,List)->
  lists:foreach(Fun,List).

%% fun(X) -> X rem 2 == 0 end
filter(Pred,List) ->
  lists:filter(Pred, List).
filter_one(Pred,List) ->
  case lists:filter(Pred, List) of
    [Hd|_Less]->Hd;
    _Other ->?NOT_SET
  end.

%% fun(X) -> X * 2 end
map(Pred,List) ->
  lists:map(Pred, List).
