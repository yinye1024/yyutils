%%%-------------------------------------------------------------------
%%% @author sunbirdjob
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 七月 2021 16:24
%%%-------------------------------------------------------------------
-module(yyu_exmp_ticker_mgr).
-author("yinye").

-include("yyu_comm.hrl").

%% API functions defined
-export([init/0,add_loop/3,add_once/3,tick/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init() ->
  yyu_ticker_mgr:init(?MODULE),
  ?OK.

add_loop(Id,NowTime,{Cd,CdFun})->
  yyu_ticker_mgr:add_loop(?MODULE,Id,NowTime,Cd,CdFun),
  ?OK.

add_once(Id,{NowTime,DelayInSec},{Cd,CdFun})->
  yyu_ticker_mgr:add_once(?MODULE,Id,{NowTime,DelayInSec},Cd,CdFun),
  ?OK.

tick(NowTime)->
  yyu_ticker_mgr:tick(?MODULE,NowTime),
  ?OK.

