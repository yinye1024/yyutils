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

-define(DIFF_SECONDS_1970_TO_1900,2208988800).
-define(DIFF_SECONDS_0000_TO_1900,62167219200).
-define(ONE_DAY_SECONDS,86400).
-define(ONE_DAY_MILLISECONDS,86400000).

-define(Hour2Sec(Hour),(Hour*60*60)).
-define(Minute2Sec(Minutes),(Minutes*60)).
-define(Sec2Ms(Seconds),(Seconds*1000)).
-define(Ms2Sec(Seconds),(Seconds div 1000)).

%% API functions defined
-export([local_time/0,datetime_to_gregorian_seconds/1]).
-export([now_time/0,now_date/0,now_date_time/0,seconds_to_date_time/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
local_time()->
  {MSec,Sec,USec} = yyu_time:timestamp(),
  calendar:now_to_local_time({MSec,Sec,USec}).

datetime_to_gregorian_seconds({Date, Time})->
  calendar:datetime_to_gregorian_seconds({Date, Time}).

%% Time = {Hour,Minutes,Seconds}
now_time()->
  {_Date,Time} = calendar:local_time(),
  Time.

%% Time = {Year,Month,Day}
now_date()->
  {Date,_Time} = calendar:local_time(),
  Date.

now_date_time()->
  calendar:local_time().

seconds_to_date_time(Seconds)->
  MegaSecs = Seconds div 1000000,
  Secs = Seconds - MegaSecs*1000000,
  calendar:now_to_local_time({MegaSecs,Secs,0}).
