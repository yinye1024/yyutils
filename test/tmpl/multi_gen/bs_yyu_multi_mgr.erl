%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_yyu_multi_mgr).
-author("yinye").

-include("yyu_comm.hrl").


%% API functions defined
-export([init/1, loop_tick/0,terminate/0]).
-define(MAX_IDLE_TIME, 30).   %% 最大闲置时间30秒，超过就退出进程，回收cursor。

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(GenId)->
  yyu_multi_mgr:init(GenId),
  ?OK.

loop_tick()->
  ?OK.

terminate()->
  ?OK.

