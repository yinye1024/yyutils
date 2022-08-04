%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_string).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([concat/1,format/2,is_String/1,is_num_str/1, tokens/2,start_with/2]).
-export([characters_to_binary/1,list_string_to_binary/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
concat(StrList) when is_list(StrList) ->
  lists:concat(StrList).

format(Format, Args)->
  io_lib:format(Format, Args).

is_String(Input)->
  io_lib:char_list(Input).

is_num_str(Input)->
  case is_list(Input) of
    ?TRUE ->
      Float = (catch erlang:list_to_float(Input)),
      Int = (catch erlang:list_to_integer(Input)),
      is_number(Float) orelse is_number(Int);
    ?FALSE ->
      ?FALSE
  end.

tokens(Input, Separator) when is_list(Input)->
  string:tokens(Input, Separator).

start_with(Prefix,Input)->
  priv_is_prefix(Prefix,Input).

priv_is_prefix([], _) -> true;
priv_is_prefix([Ch | Rest1], [Ch | Rest2]) ->
  priv_is_prefix(Rest1, Rest2);
priv_is_prefix(_, _) -> false.

characters_to_binary(Input)->
  unicode:characters_to_binary(Input).

list_string_to_binary([BsPath|Less],AccList)->
  list_string_to_binary(Less,[yyu_string:characters_to_binary(BsPath)|AccList]);
list_string_to_binary([],AccList)->
  yyu_list:reverse(AccList).
