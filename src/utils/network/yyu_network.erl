%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_network).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_ip/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% transfer num to string
get_ip(Socket) when is_port(Socket)->
  {?OK,{IP,_Port}} = inet:peername(Socket),
  {Ip0,Ip1,Ip2,Ip3}=IP,
  yyu_misc:to_binary(yyu_misc:to_list(Ip0)++"."++yyu_misc:to_list(Ip1)++"."++yyu_misc:to_list(Ip2)++"."++yyu_misc:to_list(Ip3)).


