%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   带过期时间的ets 缓存
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_ets_time_cache_dao).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([init/1,init_multi_gen_write/1,is_inited/1]).
-export([get_data/2,get_data/3, priv_get_cacheItem/2]).
-export([put_data/4,remove/2,clean/1]).
-export([check_and_clean_expired/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 一般使用这个就可以了，单进程写，多进程读，针对写少读多的情况。
init(TbName) ->
  ets:new(TbName,[set,public,named_table, {keypos,1}, {write_concurrency,false}, {read_concurrency,true}]),
  ?OK.

%% 多进程写，而且存储的数据size都比较小，只做写并发，读不并发
init_multi_gen_write(TbName) ->
  ets:new(TbName,[set,public,named_table, {keypos,1}, {write_concurrency,true},{read_concurrency,false}]),
  ?OK.

is_inited(TbName)->
  ets:info(TbName) =/= ?UNDEFINED.


get_data(TbName,Key,Default)->
  case get_data(TbName,Key) of
    ?NOT_SET -> Default;
    {ExpiredTime,Data} -> {ExpiredTime,Data}
  end.


get_data(TbName,Key)->
  case priv_get_cacheItem(TbName,Key) of
    ?NOT_SET -> ?NOT_SET;
    CachedItem ->
      ExpiredTime = yyu_ets_time_cache_item:get_expired_time(CachedItem),
      IsExpired = ExpiredTime < yyu_time:now_seconds(),
      ?IF(IsExpired,?NOT_SET, {ExpiredTime,yyu_ets_time_cache_item:get_data(CachedItem)})
  end.
priv_get_cacheItem(TbName,Key)->
  case ets:lookup(TbName,Key) of
    []-> ?NOT_SET;
    [{_Key,CachedItem}]->
      CachedItem
  end.

put_data(TbName,Key,Value,CachedTimeInSecond)->
  ExpiredTime = yyu_time:now_seconds() + CachedTimeInSecond,
  CacheItem = yyu_ets_time_cache_item:new(Key,Value,ExpiredTime),
  ?TRUE = ets:insert(TbName,{Key,CacheItem}),
  ?OK.

remove(TbName,Key)->
  ?TRUE = ets:delete(TbName,Key),
  ?OK.

clean(TbName)->
  ets:delete_all_objects(TbName),
  ?OK.

check_and_clean_expired(TbName)->
  AllExpiredList = priv_get_all_expired_key_list(TbName),
  priv_clean_expired(AllExpiredList,TbName).
priv_get_all_expired_key_list(TbName)->
  NowTime = yyu_time:now_seconds(),
  Q = ets:fun2ms(fun({Key,#{expired_time => ExpiredTime}}) when NowTime > ExpiredTime -> Key end),
  KeyList = ets:select(TbName,Q),
  KeyList.
priv_clean_expired([Key|Less],TbName)->
  remove(TbName,Key),
  priv_clean_expired(Less,TbName);
priv_clean_expired([],_TbName)->
  ?OK.





