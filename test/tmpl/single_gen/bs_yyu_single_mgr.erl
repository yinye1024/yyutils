%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_yyu_single_mgr).
-author("yinye").

-include("yyu_comm.hrl").


%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  ?OK.

loop_tick()->
  ?OK.

persistent()->
  ?OK.

terminate()->
  ?OK.
