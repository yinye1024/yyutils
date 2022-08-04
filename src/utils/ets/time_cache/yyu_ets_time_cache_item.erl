%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_ets_time_cache_item).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([new/3,get_key/1]).
-export([get_data/1,set_data/2]).
-export([get_expired_time/1,set_expired_time/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new(Key,Data,ExpiredTime)->
  #{
    key => Key,
    data => Data,
    expired_time => ExpiredTime
  }.

get_key(ItemMap) ->
  yyu_map:get_value(key, ItemMap).

get_data(ItemMap) ->
  yyu_map:get_value(data, ItemMap).

set_data(Value, ItemMap) ->
  yyu_map:put_value(data, Value, ItemMap).



get_expired_time(ItemMap) ->
  yyu_map:get_value(expired_time, ItemMap).

set_expired_time(Value, ItemMap) ->
  yyu_map:put_value(expired_time, Value, ItemMap).

