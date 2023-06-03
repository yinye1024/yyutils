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
-export([local_time/0,datetime_to_gregorian_seconds/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
local_time()->
  {MSec,Sec,USec} = yyu_time:timestamp(),
  calendar:now_to_local_time({MSec,Sec,USec}).

datetime_to_gregorian_seconds({Date, Time})->
  calendar:datetime_to_gregorian_seconds({Date, Time}).



