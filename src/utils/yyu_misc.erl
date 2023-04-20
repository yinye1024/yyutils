%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%      For those utils have no way to go, home them here.
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_misc).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([num2string/1]).
-export([build_gen_name/2]).
-export([sub_atom/2,list_to_atom/1]).
-export([to_atom/1,to_list/1,to_binary/1,to_float/1,to_integer/1,to_tuple/1]).
-export([term_to_string/1,string_to_term/1,string_to_num/1]).
-export([term_to_bin/1, bin_to_term/1]).
-export([get_ip/1]).
-export([incr_ver/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% transfer num to string
num2string(N)  when is_integer(N)->
  erlang:integer_to_list(N);
num2string(N)  when is_float(N)->
  num2string(N).

%% 根据Mod和Id 创建gen的唯一标识
build_gen_name(Mod,GenId) when is_atom(Mod) andalso is_number(GenId)->
 to_atom( to_list(Mod)++"_"++num2string(GenId)).

to_atom(Input) when is_atom(Input)->
  Input;
to_atom(Input) when is_binary(Input)->
  erlang:binary_to_atom(Input,utf8);
to_atom(Input) when is_list(Input)->
  yyu_misc:list_to_atom(Input);
to_atom(_Input) ->
  throw(input_error).

sub_atom(Atom,Len)->
  yyu_misc:list_to_atom( lists:sublist( atom_to_list(Atom),Len ) ).

list_to_atom(List)  when is_list(List)->
  case catch(erlang:list_to_existing_atom(List) ) of
    {'EXIT',_}->
      erlang:list_to_atom(List);
    Atom when is_atom(Atom)->
      Atom
  end.

to_list(Input) when is_list(Input)->
  Input;
to_list(Input) when is_atom(Input)->
  erlang:atom_to_list(Input);
to_list(Input) when is_binary(Input)->
  erlang:binary_to_list(Input);
to_list(Input) when is_integer(Input)->
  erlang:integer_to_list(Input);
to_list(Input) when is_float(Input)->
  erlang:float_to_list(Input);
to_list(Input) when is_tuple(Input)->
  erlang:tuple_to_list(Input);
to_list(Input) when is_pid(Input)->
  erlang:pid_to_list(Input);
to_list(Input) when is_port(Input)->
  erlang:port_to_list(Input);
to_list(_Input) ->
  throw(input_error).

to_binary(Input) when is_binary(Input)->
  Input;
to_binary(Input) when is_atom(Input)->
  erlang:list_to_binary(yyu_misc:to_list(Input));
to_binary(Input) when is_list(Input)->
  erlang:list_to_binary(Input);
to_binary(Input) when is_integer(Input)->
  erlang:integer_to_binary(Input);
to_binary(Input) when is_float(Input)->
  erlang:float_to_binary(Input);
to_binary(_Input) ->
  throw(input_error).

to_float(Input)->
  InputTmp = to_list(Input),
  erlang:list_to_float(InputTmp).

to_integer(Input) when is_integer(Input)->
  Input;
to_integer(Input) when is_binary(Input)->
  InputTmp = to_list(Input),
  erlang:list_to_integer(InputTmp);
to_integer(Input) when is_list(Input)->
  erlang:list_to_integer(Input);
to_integer(Input) when is_float(Input)->
  erlang:round(Input);
to_integer(_Input) ->
  throw(input_error).

to_tuple(Input) when is_tuple(Input)->
  Input;
to_tuple(Input) when is_list(Input)->
  erlang:list_to_tuple(Input);
to_tuple(Input) ->
  {Input}.

%% @doc term 序列化，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
  to_list(to_binary(io_lib:format("~w",[Term]))).
%% @doc term 反序列化，e.g., “[{a},1]” => [{a},1]
string_to_term(Input) when is_list(Input)->
  case erl_scan:string(Input ++".") of
    {?OK, Tokens,_}->
      case erl_parse:parse_term(Tokens) of
        {?OK,Term} -> Term;
        _Err ->  ?UNDEFINED
      end;
    _Error ->
      ?UNDEFINED
  end.

term_to_bin(Term)->
  erlang:term_to_binary(Term).
bin_to_term(Bin)->
  erlang:binary_to_term(Bin).

string_to_num(Str)->
  case lists:member($.,Str) of
    ?TRUE -> erlang:list_to_float(Str);
    ?FALSE-> erlang:list_to_integer(Str)
  end.

get_ip(Socket) ->
  {?OK,{IP,_Port}} = inet:peername(Socket),
  {Ip0,Ip1,Ip2,Ip3}=IP,
  to_binary(to_list(Ip0)++"."++to_list(Ip1)++"."++to_list(Ip2)++"."++to_list(Ip3)).

%% 统一版本号增加,超过short返回1
incr_ver(Ver)->
  ?IF(Ver > ?MAX_SHORT,1,Ver+1).
