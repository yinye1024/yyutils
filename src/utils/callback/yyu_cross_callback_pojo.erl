%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   跨节点的callback 用这个
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_cross_callback_pojo).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([new_cb/1,new_cb/2, do_callback/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_cb(CallbackFun) when is_function(CallbackFun)->
  #{
    pid => yyu_cross_utils:pid_2_bin(self()),
    cb_fun => CallbackFun
  }.
new_cb(CallbackFun,LocalParam)->
  Cb = new_cb(CallbackFun),
  Cb#{
    param => LocalParam
  }.

do_callback(_CbParam,?NOT_SET)->?OK;
do_callback(CbParam,ItemMap)->
  case priv_get_cb_fun(ItemMap) of
    ?NOT_SET ->?OK;
    CbFun ->
      BinPid = priv_get_pid(ItemMap),
      CrossPid = yyu_cross_utils:bin_2_pid(BinPid),
      case priv_get_param(ItemMap) of
        ?NOT_SET ->
          CbFun(CrossPid,CbParam),
          ?OK;
        LocalParam ->
          CbFun(CrossPid,CbParam,LocalParam),
          ?OK
      end
  end,
  ?OK.

priv_get_pid(ItemMap) ->
  yyu_map:get_value(pid, ItemMap).
priv_get_cb_fun(ItemMap) ->
  yyu_map:get_value(cb_fun, ItemMap).
priv_get_param(ItemMap) ->
  yyu_map:get_value(param, ItemMap).



