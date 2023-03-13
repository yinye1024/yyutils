%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_ver_cache_item).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([new/2,new/3,get_key/1, get_ver/1,incr_ver/1]).
-export([get_data/1,set_data/2]).
-export([get_update_fun/1,set_update_fun/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new({Key,Data,Ver},UpdateFun)->
  #{
    key => Key,
    data => Data,
    update_fun => UpdateFun,
    ver => Ver
  }.

new(Key,Data,Ver)->
  #{
    key => Key,
    data => Data,
    update_fun => ?NOT_SET,
    ver => Ver
  }.

get_key(ItemMap) ->
  yyu_map:get_value(key, ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).


get_data(ItemMap) ->
  yyu_map:get_value(data, ItemMap).

set_data(Value, ItemMap) ->
  yyu_map:put_value(data, Value, ItemMap).



get_update_fun(ItemMap) ->
  yyu_map:get_value(update_fun, ItemMap).

set_update_fun(Value, ItemMap) ->
  yyu_map:put_value(update_fun, Value, ItemMap).

