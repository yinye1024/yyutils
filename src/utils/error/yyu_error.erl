%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_error).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([throw_error/1,throw_error/2,assert_true/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
throw_error(ErrorReason)->
  throw({error,ErrorReason}).
throw_error(ErrorBsType,ErrorReason)->
  throw({ErrorBsType,ErrorReason}).


%% 断言，失败的时候抛出异常，中断当前流程
assert_true(IsTrue, Tips)->
  case IsTrue of
    ?TRUE ->
      ?OK;
    ?FALSE ->
      throw({assert_error,Tips})
  end.
