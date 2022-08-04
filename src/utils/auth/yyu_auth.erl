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
-export([to_md5/1,to_lowercase_md5/1,to_upercase_md5/1]).


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
