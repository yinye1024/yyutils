%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%   当从db load数据比较慢，导致服务启动慢的时候，可以用dets来加速
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_dets_dao).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([init/2,init/3,to_ets/2,from_ets/2,close/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(DTbName,FilePath) ->
  %% 有 dets 文件，以read only 的方式打开避免文件改动
  IsReadOnly = yyu_file:is_file(FilePath),
  init(DTbName,FilePath,IsReadOnly),
  ?OK.
init(DTbName,FilePath,IsReadOnly) ->
  case IsReadOnly of
    ?TRUE ->
      %% 有 dets 文件，以read only 的方式打开避免文件改动
      dets:open_file(DTbName,[{file,FilePath},{'access','read'}]),
      ?OK;
    ?FALSE ->
      %% 第一次，写入空的 dets文件
      dets:open_file(DTbName,[{file,FilePath}]),
      ?OK
  end,
  ?OK.

close(DTb)->
  dets:close(DTb).

from_ets(DTb, ETb)->
  dets:from_ets(DTb, ETb).

to_ets(DTb, ETb)->
  dets:to_ets(DTb, ETb).
