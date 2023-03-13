%%%-------------------------------------------------------------------
%%% @author sunbirdjob
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 七月 2021 16:24
%%%-------------------------------------------------------------------
-module(yyu_ticker_pojo).
-author("yinye").

-include("yyu_comm.hrl").

%% API functions defined
-export([new_pojo/4]).
-export([get_id/1, is_loop/1]).
-export([is_do_fun_time/2,reset_do_fun_time/2,do_fun/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Id,NowTime,Delay,{Cd,CdFun,IsLoop,Param}) ->
  #{
    id=>Id,
    is_loop=>IsLoop, %% 是否循环执行，不是的话执行完后会删除
    cd => Cd,
    next_do_fun_time => NowTime + Delay, %% 有延迟的话加入延迟计数 Delay
    cd_fun => CdFun,
    param => Param
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

is_do_fun_time(NowTime,ItemMap)->
  get_next_do_fun_time(ItemMap) < NowTime.

do_fun(NowTime,ItemMap)->
  Fun = get_cd_fun(ItemMap),
  case get_param(ItemMap) of
    ?NOT_SET ->
      case yyu_fun:is_fun(Fun,0) of
        ?TRUE -> Fun();
        ?FALSE -> Fun(NowTime)
      end;
    Param ->Fun(NowTime,Param)
  end,
  ?OK.

reset_do_fun_time(NowTime,ItemMap)->
  NextDoTime = NowTime + get_cd(ItemMap),
  set_next_do_fun_time(NextDoTime,ItemMap).


get_next_do_fun_time(ItemMap) ->
  yyu_map:get_value(next_do_fun_time, ItemMap).

set_next_do_fun_time(Value, ItemMap) ->
  yyu_map:put_value(next_do_fun_time, Value, ItemMap).

is_loop(ItemMap)->
  yyu_map:get_value(is_loop, ItemMap).

get_cd(ItemMap) ->
  yyu_map:get_value(cd, ItemMap).

get_cd_fun(ItemMap) ->
  yyu_map:get_value(cd_fun, ItemMap).

get_param(ItemMap) ->
  yyu_map:get_value(param, ItemMap).


