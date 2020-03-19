%%%-------------------------------------------------------------------
%% @doc dmdbserver public API
%% @end
%%%-------------------------------------------------------------------

-module(dmdbserver_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
	    {'_', [
		    {"/websocket", ws, []}
	    ]}
	]),
	{ok, _} = cowboy:start_clear(my_http_listener,
	    [{port, 8080}],
	    #{env => #{dispatch => Dispatch}}
	),
    Res = dmdbserver_sup:start_link(),
    io:format("~p", [Res]),
    Res.

stop(_State) ->
    ok.

%% internal functions
