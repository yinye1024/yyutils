%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_multi_dao).
-author("yinye").

-include("yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).
-define(DATA_ID,1).

%% API functions defined
-export([init/1, get_data/0, put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(GenId)->
  yyu_proc_cache_dao:init(?DATA_TYPE),
  DataPojo = yyu_multi_pojo:new_pojo(?DATA_ID, GenId),
  yyu_proc_cache_dao:put_data(?DATA_TYPE,?DATA_ID,DataPojo),
  ?OK.

put_data(DataPojo)->
  yyu_proc_cache_dao:put_data(?DATA_TYPE,?DATA_ID,DataPojo),
  ?OK.

get_data()->
  DataPojo = yyu_proc_cache_dao:get_data(?DATA_TYPE,?DATA_ID),
  DataPojo.
