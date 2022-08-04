%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_pid).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([is_local_alive/1, is_global_alive/1,kill_pid/2,proc_gc/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
is_local_alive(Pid) when is_pid(Pid)->
  is_process_alive(Pid).

%% 慎用 跨节点会使用call-，本地会转换成 process_info(Pid)
is_global_alive(Pid) when is_pid(Pid)->
  is_list(rpc:pinfo(Pid)).

kill_pid(Pid,Reason) when is_pid(Pid)->
  exit(Pid,Reason).

%% 进程gc
proc_gc(Pid)->
  erlang:garbage_collect(Pid),
  ?OK.

