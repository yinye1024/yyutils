%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_time).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([timestamp/0,now_seconds/0,now_milliseconds/0,sleep/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================

%% 时间总控，改变这个改变所有时间，方便做时间相关的测试
timestamp()->
  {A,B,C} = os:timestamp(),
  {A,B + priv_get_dev_time(),C}.
priv_get_dev_time()->
  0.

now_seconds()->
  {A,B,_} = timestamp(),
  A * 1000000 + B.

now_milliseconds() ->
  {A,B,C} = timestamp(),
  A * 1000000000 + B*1000 + C div 1000.

%% 阻塞当前进程 Time/毫秒
sleep(MilliSec)->
  timer:sleep(MilliSec).

