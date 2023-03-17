%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   当前节点的callback 用这个
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_local_callback_pojo).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([new_cb/1,new_cb/2, do_callback/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_cb(CallbackFun) when is_function(CallbackFun)->
  #{
    pid => self(),
    cb_fun => CallbackFun
  }.
new_cb(CallbackFun,LocalParam)->
  Cb = new_cb(CallbackFun),
  Cb#{
    param = LocalParam
  }.

do_callback(_CbParam,?NOT_SET)->?OK;
do_callback(CbParam,ItemMap)->
  case priv_get_cb_fun(ItemMap) of
    ?NOT_SET ->?OK;
    CbFun ->
      Pid = priv_get_pid(ItemMap),
      case priv_get_param(ItemMap) of
        ?NOT_SET ->
          CbFun(Pid,CbParam),
          ?OK;
        LocalParam ->
          CbFun(Pid,CbParam,LocalParam),
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



