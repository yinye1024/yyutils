%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 四月 2021 11:50
%%%-------------------------------------------------------------------
-author("yinye").
-include("yyu_comm_atoms.hrl").
-include("yyu_logger.hrl").

-ifndef(YYU_COMM).
-define(YYU_COMM,yyu_comm_hrl).


-define(MIN_SHORT,-32768).
-define(MAX_SHORT,32767).
-define(MIN_INT_32,-2147483648).
-define(MAX_INT_32,2147483647).
-define(MIN_INT_64,-9223372036854775808).
-define(MAX_INT_64,9223372036854775807).

-define(GEN_CALL_TIMEOUT,5000).  %% 进程 call 超时时间
-define(GEN_PERSIST_SPAN,5*1000).  %% 进程进行持久化的间隔时间，默认5分钟
-define(GEN_TICK_SPAN,1000).  %% 进程tick的时间，默认1秒 tick 一次

-define(DO_FUN(Fun,Param),{do_fun,Fun,Param}).
-define(IF(C,TF,FF),(case (C) of ?TRUE ->(TF);?FALSE->(FF) end)).
-define(IF(C,TF),(case (C) of ?TRUE ->(TF);?FALSE->?OK end)).
-define(TRY_CATCH(DoFun),
        try
          DoFun
        catch
          throw:done ->?OK;
          Error:Reason ->
            ?LOG_ERROR({error,[Error,Reason,erlang:get_stacktrace()]})
        end).

-endif.
