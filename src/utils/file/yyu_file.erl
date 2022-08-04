%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_file).
-author("yinye").
-include("yyu_comm_atoms.hrl").

%% API functions defined
-export([is_file/1,is_dir/1,ensure_dir/1,read_text_file_utf8/1,foreach_line/2,write_file/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
is_file(FilePath) ->
  filelib:is_file(FilePath).

is_dir(DirPath) ->
  filelib:is_dir(DirPath).

ensure_dir(DirPath) ->
  filelib:ensure_dir(DirPath).

read_text_file_utf8(FilePath)->
  {?OK,Bin} = file:read_file(FilePath),
  {_Encoding,BomLen} = unicode:bom_to_encoding(Bin),
  <<_:BomLen/binary,BodyBin/binary>> = Bin,
  Utf8Bin = unicode:characters_to_binary(BodyBin,utf8),
  binary_to_list(Utf8Bin).

foreach_line(FilePath,LineHandleFun)->
  {?OK,Bin} = file:open(FilePath,read),
  ResultList = private_handle_line(Bin,LineHandleFun,[]),
  file:close(Bin),
  ResultList.
private_handle_line(Bin,LineHandleFun,AccList)->
  case io:get_line(Bin,"") of
    eof ->
      AccList;
    Line ->
      NewResult = LineHandleFun(Line),
      private_handle_line(Bin,LineHandleFun,[NewResult|AccList])
  end.

write_file(FilePath,Term)->
  {?OK,IO} = file:open(FilePath,write),
  io:format(IO,"~p",Term),
  file:close(IO).


