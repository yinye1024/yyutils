%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   当从db load数据比较慢，导致服务启动慢的时候，可以用dets来加速
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_cross_utils).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([pid_2_bin/1,bin_2_pid/1]).
-export([fun_to_bin/1,bin_to_fun/1]).
-export([param_to_bin/1,bin_to_param/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 会带上pid所在节点的信息，实现跨节点进程调用
pid_2_bin(Pid) when is_pid(Pid)->
  yyu_misc:term_to_bin(Pid).
bin_2_pid(PidBin) when is_binary(PidBin)->
  yyu_misc:bin_to_term(PidBin).

fun_to_bin(Fun) when is_function(Fun)->
  yyu_misc:term_to_bin(Fun).
bin_to_fun(FunBin) when is_binary(FunBin)->
  yyu_misc:bin_to_term(FunBin).

param_to_bin(Param) when is_function(Param)->
  yyu_misc:term_to_bin(Param).
bin_to_param(Param) when is_binary(Param)->
  yyu_misc:bin_to_term(Param).