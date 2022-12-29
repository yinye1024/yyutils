%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_fun).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([is_fun_exported/3,safe_run/1]).
-export([call_do_fun/1,cast_do_fun/1,info_do_fun/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
is_fun_exported(?NOT_SET,_FunName, _ArityNum)->
  ?FALSE;
is_fun_exported(ModName, FunName, ArityNum)->
  case erlang:module_loaded(ModName) of
    ?TRUE ->
      ?OK;
    ?FALSE ->
      code:ensure_loaded(ModName),
      ?OK
  end,
  erlang:function_exported(ModName, FunName, ArityNum).


safe_run(Fun)->
  try
      case erlang:is_function(Fun) of
        ?TRUE -> Fun();
        ?FALSE ->{?FAIL}
      end
  catch
      ErrorType:ErrorReason:Stacktrace  ->
        ?LOG_ERROR({ErrorType,ErrorReason,Stacktrace}),
        {?FAIL}
  end.

call_do_fun({do_fun,Fun,Param}) when is_list(Param)->
  erlang:apply(Fun,Param);
call_do_fun(_Msg)->
  ?UNKNOWN.

cast_do_fun({do_fun,Fun,Param}) when is_list(Param)->
  erlang:apply(Fun,Param),
  ?OK;
cast_do_fun(_Msg)->
  ?UNKNOWN.

info_do_fun({do_fun,Fun,Param}) when is_list(Param)->
  erlang:apply(Fun,Param),
  ?OK;
info_do_fun(_Msg)->
  ?UNKNOWN.
