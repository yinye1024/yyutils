%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 三月 2021 13:51
%%%-------------------------------------------------------------------
-module(yyu_auth).
-author("yinye").


%% API functions defined
-export([to_md5/1,to_lowercase_md5/1,to_upercase_md5/1,build_time_ticket/3,check_time_ticket/4]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
to_md5(InputStr) ->
  lists:flatten([ io_lib:format("~2.16.0b",[N]) ||  N <- erlang:binary_to_list(erlang:md5(InputStr)) ]).

to_lowercase_md5(InputStr) ->
  <<N:128>> = to_md5(InputStr),
  lists:flatten(io_lib:format("~32.16.0b",[N])).

to_upercase_md5(InputStr) ->
  <<N:128>> = to_md5(InputStr),
  lists:flatten(io_lib:format("~32.16.0B",[N])).


build_time_ticket(UserId,Time,Key)->
  Md5Str = [yyu_misc:to_list(UserId),yyu_misc:to_list(Time),yyu_misc:to_list(Key)],
  Ticket = to_lowercase_md5(Md5Str),
  Ticket.

check_time_ticket(UserId,Time,Key,TicketP)->
  TicketP == build_time_ticket(UserId,Time,Key).

