%%%-------------------------------------------------------------------
%%% @author zenmind
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 四月 2021 11:50
%%%-------------------------------------------------------------------
-author("zenmind").

-ifndef(YYU_ETS_DB).
-define(YYU_ETS_DB,yyu_ets_db_hrl).


-record(yyu_ets_db_edata,
{
  key,
  data,
  update_fun,
  ver
}).



-endif.