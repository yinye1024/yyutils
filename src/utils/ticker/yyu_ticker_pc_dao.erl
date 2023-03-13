%%%-------------------------------------------------------------------
%%% @author sunbirdjob
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 七月 2021 16:24
%%%-------------------------------------------------------------------
-module(yyu_ticker_pc_dao).
-author("yinye").

-include("yyu_comm.hrl").

%% API functions defined
-export([init/1,put_data/2,get_data/2,remove_data/2,get_all_list/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(DTypeId) ->
  yyu_proc_cache_dao:init(DTypeId),
  ?OK.

put_data(DTypeId,TickerPojo)->
  TickerId = yyu_ticker_pojo:get_id(TickerPojo),
  yyu_proc_cache_dao:put_data(DTypeId,TickerId,TickerPojo),
  ?OK.

get_data(DTypeId,TickerId)->
  TickerPojo = yyu_proc_cache_dao:get_data(DTypeId,TickerId),
  TickerPojo.

remove_data(DTypeId,TickerId)->
  yyu_proc_cache_dao:remove_data(DTypeId,TickerId),
  ?OK.

get_all_list(DTypeId)->
  TickerMap = yyu_proc_cache_dao:get_all_map(DTypeId),
  yyu_map:all_values(TickerMap).
