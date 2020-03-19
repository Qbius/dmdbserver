%%%-------------------------------------------------------------------
%% @doc dmdbserver public API
%% @end
%%%-------------------------------------------------------------------

-module(dmdbserver_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    dmdbserver_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
