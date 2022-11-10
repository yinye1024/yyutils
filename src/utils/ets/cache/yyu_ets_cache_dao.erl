%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   当从db load数据比较慢，导致服务启动慢的时候，可以用dets来加速
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_ets_cache_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/1,init_multi_gen_write/1,is_inited/1]).
-export([is_exist/2,get_data/2,get_data/3,select_all_by_Q/2,get_all_kvList/1, get_all_keyList/1, get_all_valueList/1,get_all_map/1]).
-export([put_data/2,put_data/3,remove/2,select_remove/2,clean/1]).
-export([foreach/3,get_total_count/1,incr_and_get/3]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 一般使用这个就可以了，单进程写，多进程读，针对写少读多的情况。
init(TbName) ->
  ets:new(TbName,[set,public,named_table, {keypos,1}, {write_concurrency,false}, {read_concurrency,true}]),
  ?OK.

%% 多进程读写，而且存储的数据size都比较小，只做写并发，读不并发
init_multi_gen_write(TbName) ->
  ets:new(TbName,[set,public,named_table, {keypos,1}, {write_concurrency,true},{read_concurrency,false}]),
  ?OK.

is_inited(TbName)->
  ets:info(TbName) =/= ?UNDEFINED.


is_exist(TbName,Key)->
  get_data(TbName,Key) =/= ?NOT_SET.

get_data(TbName,Key)->
  case ets:lookup(TbName,Key) of
    []-> ?NOT_SET;
    [{_Key,Value}]->Value
  end.
get_data(TbName,Key,Default)->
  case ets:lookup(TbName,Key) of
    []-> Default;
    [{_Key,Value}]->Value
  end.


select_all_by_Q(TbName,Q)->
  ets:select(TbName,Q).

get_all_kvList(TbName)->
  KvList = ets:tab2list(TbName),
  KvList.

get_all_map(TbName)->
  KvList = get_all_kvList(TbName),
  yyu_map:from_kv_list(KvList).

get_all_keyList(TbName)->
  All = get_all_kvList(TbName),
  [Key || {Key,_Value} <- All].

get_all_valueList(TbName)->
  All = get_all_kvList(TbName),
  [Value || {_Key,Value} <- All].


put_data(TbName,Key,Value)->
  ?TRUE = ets:insert(TbName,{Key,Value}),
  ?OK.

put_data(TbName,KvList) when is_list(KvList)->
  ?TRUE = ets:insert(TbName,KvList),
  ?OK.

remove(TbName,Key)->
  ?TRUE = ets:delete(TbName,Key),
  ?OK.

%% e.g. MatchSpec = [{ { [MarkNo, '_'], '$1' }, [], [true] }]
%% 参考 MatchSpec 语法
select_remove(TbName,MatchSpec)->
  ets:select_delete(TbName,MatchSpec),
  ?OK.

clean(TbName)->
  ets:delete_all_objects(TbName),
  ?OK.


foreach(Fun,Acc,TbName)->
  %% e.g. Fun = fun({Key,Value},Acc)-> Acc_Value end,
  Result = ets:foldl(Fun,Acc,TbName),
  Result.

get_total_count(TbName) ->
  ets:info(TbName,size).

%% 原子操作
incr_and_get(TbName,Key,Incr)->
  NewValue = ets:update_counter(TbName,Key,Incr),
  NewValue.


