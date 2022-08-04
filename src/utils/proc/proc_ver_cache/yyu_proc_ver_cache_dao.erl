%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_proc_ver_cache_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1,get_pdata/2,get_all/1,set_pdata/2,set_pdata/3]).
-export([get_all_key_ver_list/1, get_need_syn_pdataList/2,syn_pdata_list/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(ProcId) when is_atom(ProcId)->
  DataMap = yyu_map:new_map(),
  put(ProcId,DataMap),
  ?OK.

get_pdata(ProcId,Key)->
  DataMap = get(ProcId),
  PData = yyu_map:get_value(Key,DataMap),
  PData.

get_all_key_ver_list(ProcId)->
  DataMap = get(ProcId),
  KvList = yyu_map:to_kv_list(DataMap),
  priv_get_all_key_ver_list(KvList,[]).
priv_get_all_key_ver_list([{Key,Pdata}|Less],AccList)->
  Ver = yyu_proc_data:get_ver(Pdata),
  priv_get_all_key_ver_list(Less,[{Key,Ver}|AccList]);
priv_get_all_key_ver_list([],AccList)->
  yyu_list:reverse(AccList).

get_need_syn_pdataList(ProcId,KeyVerList)->
  DataMap = get(ProcId),
  KvList = yyu_map:to_kv_list(DataMap),
  KeyVerMap = yyu_map:from_kv_list(KeyVerList),
  priv_get_all_key_ver_list(KvList,KeyVerMap,[]).
priv_get_all_key_ver_list([{Key,Pdata}|Less],KeyVerMap,AccList)->
  NewAccList =
  case yyu_map:get_value(Key,KeyVerMap) of
    ?NOT_SET -> AccList;
    CheckVer ->
      CurVer = yyu_proc_data:get_ver(Pdata),
      TmpAccList =
      case CurVer > CheckVer of
        ?TRUE -> [Pdata|AccList];
        ?FALSE -> AccList
      end,
      TmpAccList
  end,
  priv_get_all_key_ver_list(Less,NewAccList);
priv_get_all_key_ver_list([],_KeyVerMap,AccList)->
  AccList.


syn_pdata_list(ProcId,PdataList)->
  priv_syn_pdata_list(PdataList,ProcId),
  ?OK.
priv_syn_pdata_list([NewPdata|Less],ProcId)->
  Key = yyu_proc_data:get_key(NewPdata),
  case get_pdata(ProcId,Key) of
    ?NOT_SET -> ?OK;
    OldData ->
      set_pdata(ProcId, OldData, NewPdata),
      ?OK
  end,
  priv_syn_pdata_list(Less,ProcId);
priv_syn_pdata_list([],_ProcId)->
  ?OK.



get_all(ProcId)->
  DataMap = get(ProcId),
  DataMap.

set_pdata(ProcId, NewPdata)->
  Key = yyu_proc_data:get_key(NewPdata),
  Result = priv_put_pdata(ProcId,Key,NewPdata),
  Result.

set_pdata(ProcId, OldData, NewPdata)->
  Key = yyu_proc_data:get_key(NewPdata),
  OldVer = yyu_proc_data:get_ver(OldData),
  NewVer = yyu_proc_data:get_ver(NewPdata),
  case NewVer > OldVer of
    ?TRUE ->
      priv_put_pdata(ProcId,Key,NewPdata),
      ?OK;
    ?FALSE ->
      {error,"NewData ver is less than OldData"}
  end.

priv_put_pdata(ProcId,Key,Pdata)->
  DataMap = get(ProcId),
  DataMap = yyu_map:put_value(Key,Pdata,DataMap),
  put(ProcId,DataMap),
  ?OK.



