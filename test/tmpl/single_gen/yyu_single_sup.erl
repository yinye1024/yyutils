%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     网关进程，每个用户一个
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_single_sup).
-author("yinye").

-behavior(supervisor).
-include("yyu_comm.hrl").
-define(SERVER,?MODULE).


%% API functions defined
-export([start_link/0,init/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_link()->
  supervisor:start_link({local,?SERVER},?MODULE,{}).

%% one_for_one 的child，sup start_link 之后会自动拉起进程
init({}) ->
  ChileSpec = #{
    id=> yyu_single_gen,
    start => {yyu_single_gen,start_link,[]},
    restart => permanent,  %% 挂了就重启
    shutdown => 20000,
    type => worker,
    modules => [yyu_single_gen]
  },
  {?OK,{ {one_for_one,10,10},[ChileSpec]} }.



