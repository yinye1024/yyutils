%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_logger).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([start/0,error/2,warning/2,info/2,debug/2]).
-export([display/1]).
-compile([{parse_transform, lager_transform}]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================

start() ->
  application:load(lager),

  %% 设置log根目录
  application:set_env(lager,log_root,"log"),
  %% 设置handler
  application:set_env(lager,handlers,
    [
     {lager_console_backend, [{level, debug}]},
     {lager_file_backend, [{file, "error.log"}, {level, error},{size, 10485760}, {date, "$D0"}, {count, 5}]},
     {lager_file_backend, [{file, "info.log"}, {level, info},{size, 10485760}, {date, "$D0"}, {count, 5}]}
    ]),
  %% 默认异步，当堆积超过20切换成同步
  application:set_env(lager,async_threshold,20),
  %% 堆积超过20改成同步后，低于20-5=15 重新切换成异步
  application:set_env(lager,async_threshold_window,5),
  %% 每秒只允许从error_logger 发50条到lager
  application:set_env(lager,error_logger_hwm,50),


  %% 切换成同步模式后，如果error_logger 堆积超过1000，超过的直接丢弃
  application:set_env(lager,error_logger_flush_queue,true),
  application:set_env(lager,error_logger_flush_threshold,1000),
  %% 切换成同步模式后，如果lager 堆积超过1000，超过的直接丢弃
  application:set_env(lager,flush_queue,true),
  application:set_env(lager,flush_threshold,1000),

  %% gen_event mailbox 超过1000，直接kill掉lager，5秒后重启
  application:set_env(lager, killer_hwm, 2000),
  application:set_env(lager, killer_reinstall_after, 5000),

  lager:start(),
  ?OK.

error(TupleMsg,{ModName,FunName,Line}) when is_tuple(TupleMsg)->

  TimeAndMFL = priv_get_time_and_mfl({ModName,FunName,Line}),
  lager:error(TimeAndMFL ++ " ~p \r\n",[TupleMsg]),
  ?OK.

warning(TupleMsg,{ModName,FunName,Line}) when is_tuple(TupleMsg)->
  TimeAndMFL = priv_get_time_and_mfl({ModName,FunName,Line}),
  lager:warning(TimeAndMFL ++ " ~p \r\n",[TupleMsg]),
  ?OK.

info(TupleMsg,{ModName,FunName,Line}) when is_tuple(TupleMsg)->
  TimeAndMFL = priv_get_time_and_mfl({ModName,FunName,Line}),
  lager:info(TimeAndMFL ++ " ~p \r\n",[TupleMsg]),
  ?OK.

debug(TupleMsg,{ModName,FunName,Line}) when is_tuple(TupleMsg)->
  TimeAndMFL = priv_get_time_and_mfl({ModName,FunName,Line}),
  lager:debug(TimeAndMFL ++ " ~p \r\n",[TupleMsg]),
  ?OK.

priv_get_time_and_mfl({ModName,FunName,Line})->
  {{Y,Month,D},{H,Min,S}} = erlang:localtime(),
  TimeAndMFL = io_lib:format("~p-~2.10.0B-~2.10.0B ~2.10.0B:~2.10.0B:~2.10.0B  [~p:~p line ~p] ",[Y,Month,D,H,Min,S,ModName,FunName,Line]),
  TimeAndMFL.


display(Msg)->
  erlang:display(Msg).
