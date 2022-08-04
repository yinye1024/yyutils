%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyu_reload).
-author("yinye").
-include("yyu_comm.hrl").

%% API functions defined
-export([reload_all/0,reload_mods/1,reload_mod/1]).
-export([c_mod/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
reload_all()->
  Mods = diff_mods(),
  reload_mods(Mods).

reload_mods(Mods) when is_list(Mods) ->
  [reload_mod(Mod) || Mod <- Mods].

reload_mod(Mod)->
  case code:is_loaded(Mod) of
    {file,_}->
      case code:soft_purge(Mod) of
        ?TRUE ->
          case code:load_file(Mod) of
            {module,_}->
              ?TRUE;
            {error,_Err}->
              ?FALSE
          end;
        ?FALSE ->
          ?FALSE
      end;
    ?FALSE ->
      ?TRUE  %% 无需热更，用的时候，系统会自动加载
  end.

diff_mods() ->
  Fun = fun({M,FileName},Acc)->

          case code:is_sticky(M) of
            ?TRUE -> Acc;
            ?FALSE ->
              Md5 = proplists:get_value(md5,M:module_info()),
              case beam_lib:md5(FileName) of
                {?OK,{M,NMd5}} when NMd5 =/= Md5 ->
                  [M|Acc];
                _->
                  Acc
              end
          end

        end,

  lists:foldl(Fun,[],code:all_loaded()).

c_mod(Mod)->
  compile:file(Mod),
  code:purge(Mod),
  code:load_file(Mod),
  ?OK.

