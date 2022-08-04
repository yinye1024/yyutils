%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 四月 2021 11:50
%%%-------------------------------------------------------------------
-author("yinye").
-include("utils/log/yyu_logger.hrl").

-ifndef(YYU_GS).
-define(YYU_GS,yyu_gs_hrl).

%% 封装处理 handle_call
-define(DO_HANDLE_CALL(Req,State),
  try
    Return = do_handle_call(Req,State),
      case  Return of
        {?REPLY,_Reply,_NewState}->Return;
        {?STOP,_,_,_} ->Return;
        _->{?REPLY,{?FAIL,bad_return},State}
      end
  catch
    throw:done  ->
        {?REPLY,?OK,State};
    Err:Reason ->
      ?LOG_ERROR({[stacktrace,erlang:get_stacktrace()],[info,Req],[err,Err],[reason,Reason],[state,State]}),
      {?REPLY,{?FAIL,Reason},State}
  end
).


%% 封装处理 handle_cast
-define(DO_HANDLE_CAST(Req,State),
  try
    Return = do_handle_cast(Req,State),
      case  Return of
        {?NO_REPLY,_NewState}->Return;
        {?STOP,_,_} ->Return;
        _->{?NO_REPLY,State}
      end
  catch
    throw:done  ->
        {?NO_REPLY,State};
    Err:Reason ->
      ?LOG_ERROR({[stacktrace,erlang:get_stacktrace()],[info,Req],[err,Err],[reason,Reason],[state,State]}),
      {?NO_REPLY,State}
  end
).


%% 封装处理 handle_info
-define(DO_HANDLE_INFO(Req,State),
  try
    Return = do_handle_info(Req,State),
      case  Return of
        {?NO_REPLY,_NewState}->Return;
        {?STOP,_,_} ->Return;
        _->{?NO_REPLY,State}
      end
  catch
    throw:done  ->
        {?NO_REPLY,State};
    Err:Reason ->
      ?LOG_ERROR({[info,Req],[err,Err],[reason,Reason],[state,State]}),
      {?NO_REPLY,State}
  end
).

%% 封装处理 handle_info
-define(DO_TERMINATE(Reason,State),
  try
    do_terminate(Reason,State)
  catch
    Err:Reason ->
      ?LOG_ERROR({[info, Reason],[err,Err],[reason,Reason],[state,State]}),
      ?OK
  end
).


-endif.
