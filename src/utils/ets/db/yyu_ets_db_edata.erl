%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_ets_db_edata).
-author("yinye").
-include("yyu_comm_atoms.hrl").
-include("utils/ets/db/yyu_ets_db.hrl").

%% API functions defined
-export([new/2,get_key/1, get_ver/1,incr_ver/1]).
-export([get_data/1,set_data/2]).
-export([get_update_fun/1,set_update_fun/2]).



%% ===================================================================================
%% API functions implements
%% ===================================================================================
new({Key,Data,Ver},UpdateFun)->
  #yyu_ets_db_edata{
    key = Key,
    data = Data,
    update_fun = UpdateFun,
    ver = Ver
  }.


get_key(ItemMap) ->
  ItemMap#yyu_ets_db_edata.key.

get_ver(ItemMap) ->
  ItemMap#yyu_ets_db_edata.ver.
incr_ver(ItemMap) ->
  CurVer =   ItemMap#yyu_ets_db_edata.ver,
  NewVer = yyu_misc:incr_ver(CurVer),
  ItemMap#yyu_ets_db_edata{ver = NewVer}.


get_data(ItemMap) ->
  ItemMap#yyu_ets_db_edata.data.

set_data(Value, ItemMap) ->
  ItemMap#yyu_ets_db_edata{data = Value}.

get_update_fun(ItemMap) ->
  ItemMap#yyu_ets_db_edata.update_fun.

set_update_fun(Value, ItemMap) ->
  ItemMap#yyu_ets_db_edata{update_fun = Value}.

