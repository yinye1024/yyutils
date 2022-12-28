%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_yyu_multi_mgr).
-author("yinye").

-include("yyu_comm.hrl").


%% API functions defined
-export([start_link/0,new_child/1,close/1]).

-define(MAX_IDLE_TIME, 30).   %% 最大闲置时间30秒，超过就退出进程，回收cursor。

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_link()->
  yyu_multi_sup:start_link(),
  ?OK.

new_child(GenId)->
  {?OK,Pid} = yyu_multi_sup:new_child(GenId),
  Pid.

close(CursorPid)->
  yyu_multi_gen:do_stop(CursorPid),
  ?OK.

priv_call_fun(CursorPid,{WorkFun,Param})->
  Result = yyu_multi_gen:call_fun(CursorPid,{WorkFun,Param}),
  Result.
