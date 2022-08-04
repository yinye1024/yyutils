%%%-------------------------------------------------------------------
%%% @author sunbirdjob
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 七月 2021 16:24
%%%-------------------------------------------------------------------
-module(yyu_ticker_mgr).
-author("yinye").

-include("yyu_comm.hrl").

%% API functions defined
-export([init/1,add_loop/5,add_once/5,tick/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(DTypeId) ->
  yyu_ticker_cache_dao:init(DTypeId),
  ?OK.

add_loop(DTypeId,Id,NowTime,Cd,CdFun)->
  IsLoop = ?TRUE,
  Delay = 0,
  Param = ?NOT_SET,
  TickerPojo = yyu_ticker_pojo:new_pojo(Id,NowTime,Delay,{Cd,CdFun,IsLoop,Param}),
  yyu_ticker_cache_dao:put_data(DTypeId,TickerPojo),
  ?OK.

add_once(DTypeId,Id,{NowTime,DelayInSec},Cd,CdFun)->
  IsLoop = ?FALSE,
  Param = ?NOT_SET,
  TickerPojo = yyu_ticker_pojo:new_pojo(Id,NowTime, DelayInSec,{Cd,CdFun,IsLoop,Param}),
  yyu_ticker_cache_dao:put_data(DTypeId,TickerPojo),
  ?OK.

tick(DTypeId,NowTime)->
  TickerList = yyu_ticker_cache_dao:get_all_list(DTypeId),
  priv_tick(TickerList,{DTypeId,NowTime}),
  ?OK.
priv_tick([Ticker|Less],{DTypeId,NowTime})->
  yyu_fun:safe_run(priv_do_tick(DTypeId,Ticker,NowTime)),
  priv_tick(Less,{DTypeId,NowTime});
priv_tick([],{_DTypeId,_NowTime})->
  ?OK.

priv_do_tick(DTypeId,Ticker,NowTime)->
  case yyu_ticker_pojo:is_do_fun_time(NowTime,Ticker) of
    ?TRUE ->
      TickerTmp_1 = yyu_ticker_pojo:reset_do_fun_time(NowTime,Ticker),
      yyu_ticker_pojo:do_fun(NowTime,TickerTmp_1),
      yyu_ticker_cache_dao:put_data(DTypeId,TickerTmp_1),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  ?OK.
