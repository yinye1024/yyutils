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

-ifndef(YYU_LOGGER).
-define(YYU_LOGGER,yyu_logger_hrl).

-define(LOG_ERROR(MsgTuple), yyu_logger:error(MsgTuple,{?MODULE,?FUNCTION_NAME,?LINE})).
-define(LOG_INFO(MsgTuple), yyu_logger:info(MsgTuple,{?MODULE,?FUNCTION_NAME,?LINE})).
-define(LOG_WARNING(MsgTuple), yyu_logger:warning(MsgTuple,{?MODULE,?FUNCTION_NAME,?LINE})).
-define(LOG_DEBUG(MsgTuple), yyu_logger:debug(MsgTuple,{?MODULE,?FUNCTION_NAME,?LINE})).


-ifndef(release).
-define(TEMP(MsgTuple), yyu_logger:info({temp,MsgTuple},{?MODULE,?FUNCTION_NAME,?LINE})).
-else.
-define(TEMP(MsgTuple),?OK).
-endif.

-endif.
