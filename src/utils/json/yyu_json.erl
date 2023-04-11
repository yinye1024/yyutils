%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_json).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([struct_to_map/1,map_to_struct/1]).
-export([json_to_mapList/1,json_to_map/1,map_to_json/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
json_to_mapList(JsonStr)->
  DataList = mochijson2:decode(JsonStr),
  priv_json_to_mapList(DataList,[]).
priv_json_to_mapList([Json|Less], AccList)->
  DataTmp = struct_to_map(Json),
  priv_json_to_mapList(Less, [DataTmp|AccList]);
priv_json_to_mapList([], AccList)->
  AccList.

%% 基本类型的list 会直接返回列表
json_to_map(JsonStr)->
  Struct = mochijson2:decode(JsonStr),
  struct_to_map(Struct).
struct_to_map(Ls = [ _|_ ])->
  Fun = fun(Value) -> struct_to_map(Value) end,
  lists:map(Fun,Ls);
struct_to_map({struct, KList = [ {_,_} | _ ]})->
  Fun = fun({Key,Value}) ->
    Key2 = try binary_to_existing_atom(Key,utf8) catch _:_:_ ->Key end,
    {Key2, struct_to_map(Value)}
        end,
  Ls2 = lists:map(Fun,KList),
  maps:from_list(Ls2);
struct_to_map(V)->V.

map_to_json(Map) when is_map(Map)->
  Struct = map_to_struct(Map),
  EncodeFun = mochijson2:encoder([{utf8, true}]),
  EncodeFun(Struct).
map_to_struct(Map) when is_map(Map)->
  KvList = yyu_map:to_kv_list(Map),
  PList = priv_handle_kv(KvList,[]),
  {struct,PList}.

priv_handle_kv([{Key,Value}|Less],AccList)->
  Value_1 =priv_handle_value(Value),
  NewAccList = [{yyu_misc:to_binary(Key),Value_1}|AccList],
  priv_handle_kv(Less,NewAccList);
priv_handle_kv([],AccList)->
  AccList.


priv_handle_value(Value) when is_map(Value)->
  map_to_struct(Value);
priv_handle_value(Value) when is_list(Value)->
  case yyu_string:is_String(Value) of
    ?TRUE ->
      yyu_string:characters_to_binary(Value);
    ?FALSE ->
      priv_handle_vlist(Value,[])
  end;
priv_handle_value(Value)->
  Value.

priv_handle_vlist([Value |Less],AccList)->
  Value_1 = priv_handle_value(Value),
  priv_handle_vlist(Less,[Value_1|AccList]);
priv_handle_vlist([],AccList)->
  AccList.

