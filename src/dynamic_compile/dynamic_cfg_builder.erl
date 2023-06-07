%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%     动态编译的配置文件，对一些运行时配置进行管理，最好是配置对应的服务启动的时候做一次性 set_and_reload 操作
%%% @end
%%% Created : 30. 5月 2023 14:12
%%%-------------------------------------------------------------------
-module(dynamic_cfg_builder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([build/1, build/2]).
-export([get_value/2,get_all_value/1,set_and_reload/2]).

build(CfgMod)->
  priv_reload_cfg(CfgMod,[]),
  ?OK.

build(CfgMod,KvList)->
  priv_reload_cfg(CfgMod,KvList),
  ?OK.

get_value(CfgMod,Key) when is_atom(CfgMod)->
  case CfgMod:get(Key) of
    {?OK,Value}->Value;
    _->?UNDEFINED
  end.

get_all_value(CfgMod) when is_atom(CfgMod)->
  CfgMod:all().

set_and_reload(CfgMod,KvList) when is_atom(CfgMod)->
  ALLKvList = get_all_value(CfgMod),
  Fun = fun({Key,Value},AccList)->
          lists:keystore(Key,1,AccList,{Key,Value})
        end,
  ALLKvList_1 = lists:foldl(Fun,ALLKvList,KvList),
  priv_reload_cfg(CfgMod,ALLKvList_1),
  ?OK.

priv_reload_cfg(CfgMod,KvList) when is_atom(CfgMod)->
  ModNameStr = atom_to_list(CfgMod),
  ModuleStr = priv_format_code(ModNameStr,KvList),
  {Mod,Bin} = dynamic_compile:from_string(ModuleStr),
  code:load_binary(Mod,ModNameStr++".erl",Bin).


priv_format_code(ModNameStr, KvList)->
  GetFunStr = lists:foldl(
    fun({Key,Value},AccStr)->
      priv_gen_get_str(Key,Value) ++ AccStr
    end,"get(_) -> undefined.\n\n", KvList
  ),
  AllFunStr = io_lib:format("all()->~w.\n\n",[KvList]),
  HeadStr = io_lib:format("-module(~ts).\n -compile(export_all).\n\n\n",[ModNameStr]),
  lists:flatten(HeadStr++ GetFunStr ++ AllFunStr).

priv_gen_get_str(Key,Value)->
  io_lib:format("get(~w) -> {ok, ~w};\n",[Key,Value]).
