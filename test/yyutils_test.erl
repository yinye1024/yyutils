%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 六月 2021 19:07
%%%-------------------------------------------------------------------
-module(yyutils_test).
-author("yinye").
-include("yyu_comm.hrl").
-include_lib("eunit/include/eunit.hrl").


%% ===================================================================================
%% API functions implements
%% ===================================================================================
client_test_() ->
  ?LOG_INFO({"client test ==================="}),

  {foreach,
  fun start/0,
  fun stop/1,
  [
    fun test_1/1,
    fun test_2/1
  ]
  }.
%%  [].


start() ->
  Context = 1,
  ?LOG_INFO({"test start",Context}),
  {Context}.

stop({Context}) ->
  ?LOG_INFO({"test end",Context}),
  ?OK.


test_1({Context})->
  [
    ?_assertNotMatch(2,Context),
    ?_assertMatch(1,Context)
  ].
test_2({Context})->

  [
    ?_assertNotMatch(1,Context+1),
    ?_assertMatch(3,Context+2)
  ].





