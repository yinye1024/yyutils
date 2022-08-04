%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   带版本号的缓存，主要用来在进程之间自动同步进程缓存数据
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_ver_cache_mgr).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1,get_data/2,set_data/2]).
-export([get_all_key_ver_list/1, get_need_syn_pdataList/2,syn_pdata_list/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================

init(ProcId)->
  yyu_proc_ver_cache_dao:init(ProcId),
  ?OK.

get_data(ProcId,Key)->
  case yyu_proc_ver_cache_dao:get_pdata(ProcId,Key) of
    {?OK,Pdata} ->
      yyu_proc_data:get_data(Pdata);
    _->
      ?NOT_SET
  end.

set_data(ProcId,{Key, Data, Ver})->
  NewPdata = yyu_proc_data:new(Key,Data,Ver),
  Result =
  case yyu_proc_ver_cache_dao:get_pdata(ProcId,Key) of
    {?OK,OldPdata} ->
      yyu_proc_ver_cache_dao:set_pdata(ProcId, OldPdata, NewPdata);
    _->
      yyu_proc_ver_cache_dao:set_pdata(ProcId,NewPdata)
  end,
  Result.

get_all_key_ver_list(ProcId)->
  KeyVerList = yyu_proc_ver_cache_dao:get_all_key_ver_list(ProcId),
  KeyVerList.

%% 把本进程版本号高于KeyVerList的数据组成 PdataList 返回
get_need_syn_pdataList(ProcId,KeyVerList)->
  KeyVerList = yyu_proc_ver_cache_dao:get_need_syn_pdataList(ProcId,KeyVerList),
  KeyVerList.


%% 根据PdataList 跟新本进程数据
syn_pdata_list(ProcId,PdataList)->
  yyu_proc_ver_cache_dao:syn_pdata_list(ProcId,PdataList),
  ?OK.
