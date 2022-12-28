%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_multi_mgr).
-author("yinye").

-include("yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_last_req/0,update_last_req/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(GenId)->
  yyu_multi_dao:init(GenId),
  ?OK.

get_last_req()->
  Data = yyu_multi_dao:get_data(),
  WorkData = yyu_multi_pojo:get_last_req(Data),
  WorkData.

%% 更新最后一次请求时间，超过时间没有请求，自动退出进程
update_last_req()->
  Data = yyu_multi_dao:get_data(),
  NewData = yyu_multi_pojo:set_last_req(yyu_time:now_seconds(),Data),
  yyu_multi_dao:put_data(NewData),
  ?OK.



