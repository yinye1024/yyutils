%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(yyu_proc_db_updater).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([update/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
update({DataMapKey,VerMapKey})->
  Fun =
  fun({Key,Pdata})->
    yyu_fun:safe_run(fun() -> priv_update(VerMapKey,Key,Pdata) end)
  end,

  yyu_list:foreach(Fun,yyu_proc_db_helper:get_all_kv_list(DataMapKey)),
  ?OK.

priv_update(VerMapKey,Key,Pdata)->
  DbVer = yyu_proc_db_helper:get_ver(VerMapKey,Key),

  case DbVer < yyu_proc_data:get_ver(Pdata) of
    ?TRUE ->
      priv_do_db_update(VerMapKey,Pdata),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  ?OK.

priv_do_db_update(VerMapKey,Pdata)->

  UpdateFun = yyu_proc_data:get_update_fun(Pdata),
  Data = yyu_proc_data:get_data(Pdata),
  try
      UpdateFun(Data),
      Key = yyu_proc_data:get_key(Pdata),
      Ver = yyu_proc_data:get_ver(Pdata),
      yyu_proc_db_helper:put_ver(VerMapKey,Key,Ver),
      ?OK
  catch
    ErrorType:ErrorReason:_Stacktrace  ->
      ?LOG_ERROR({?DB_ERROR,?MODULE,ErrorType,ErrorReason}),
      ?OK
  end,
  ?OK.
