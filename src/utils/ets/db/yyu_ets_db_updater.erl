%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(yyu_ets_db_updater).
-author("yinye").
-include("yyu_comm.hrl").
-include("yyu_ets_db.hrl").

%% API functions defined
-export([update/1,update/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
update({DataTbName,VerTbName})->
  Fun =
  fun({Key, EdataVer})->
    yyu_fun:safe_run(fun() -> priv_update(VerTbName,Key, EdataVer) end)
  end,

  yyu_list:foreach(Fun,yyu_ets_db_helper:get_all_key_ver_list(DataTbName)),
  ?OK.

update({DataTbName,VerTbName},KeyList)->
  Fun =
    fun(Key)->
      case yyu_ets_db_helper:get_edata(DataTbName,Key) of
        ?NOT_SET -> ?OK;
        Edata ->
          EdataVer = Edata#yyu_ets_db_edata.ver,
          yyu_fun:safe_run(fun() -> priv_update(VerTbName,Key,EdataVer) end),
          ?OK
      end,
      ?OK
    end,
  yyu_list:foreach(Fun,KeyList),
  ?OK.

priv_update(VerTbName,Key, EdataVer)->
  DbVer = yyu_ets_db_helper:get_ver(VerTbName,Key),
  case DbVer < EdataVer of
    ?TRUE ->
      Edata = yyu_ets_db_helper:get_edata(VerTbName,Key),
      priv_do_db_update(VerTbName, Edata),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  ?OK.

priv_do_db_update(VerTbName, Edata)->

  UpdateFun = yyu_ets_db_edata:get_update_fun(Edata),
  Data = yyu_ets_db_edata:get_data(Edata),
  try
      {?OK,_NewData} = UpdateFun(Data),
      Key = yyu_ets_db_edata:get_key(Edata),
      Ver = yyu_ets_db_edata:get_ver(Edata),
      yyu_ets_db_helper:put_ver(VerTbName,Key,Ver),
      ?OK
  catch
    ErrorType:ErrorReason  ->
      ?LOG_ERROR({?DB_ERROR,?MODULE,ErrorType,ErrorReason}),
      ?OK
  end,
  ?OK.
