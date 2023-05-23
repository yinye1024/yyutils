%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_calendar).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([local_time/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
local_time()->
  NowTime = yyu_time:timestamp(),
  now_to_local_time(NowTime).
now_to_local_time({MSec,Sec,USec})->
  calendar:now_to_local_time({MSec,Sec,USec}).

