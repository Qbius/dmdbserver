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
			{"/", cowboy_static, {priv_file, dmdbserver, "index.html"}},
			{"/[...]", cowboy_static, {priv_dir, dmdbserver, "."}},
			{"/dm_images/[...]", cowboy_static, {priv_dir, dmdbserver, "dm_images"}},
			{"/icons/[...]", cowboy_static, {priv_dir, dmdbserver, "icons"}},
		    {"/websocket", ws, []}
	    ]}
	]),
	{ok, _} = cowboy:start_clear(my_http_listener,
	    [{port, 8080}],
	    #{env => #{dispatch => Dispatch}}
	),
	collaborative_decks:start_link(),
    dmdbserver_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
