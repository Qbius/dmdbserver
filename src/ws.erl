-module(ws).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([terminate/3]).
-export([websocket_info/2]).

init(Req, _State) ->
	{cowboy_websocket, Req, <<"">>}.

websocket_init(State) ->
	{ok, State}.

websocket_handle({text, Msg}, State) ->
	case jsx:decode(Msg, [return_maps]) of

		#{<<"host">> := [Deckname, Deckcode]} ->
			io:format("~nHosting ~p with code ~p", [Deckname, Deckcode]),
			ok = collaborative_decks:host(Deckname, Deckcode),
			{noreply, Deckname};

	    #{<<"join">> := Deckname} ->
			io:format("~nSomeone joined ~p", [Deckname]),
			case collaborative_decks:join(Deckname) of
				notfound ->
					{reply, {text, "Deck not found!"}, Deckname};
				Deckcode ->
			        {reply, {text, Deckcode}, State}
			end;
	    
		#{<<"move">> := Updatestr} ->
			io:format("~nChange to ~p: ~p", [State, Updatestr]),
			case collaborative_decks:move(State, Updatestr) of
				notfound ->
					{reply, {text, "Deck not found!"}, State};
				ok ->
			        {nopreply, State}
			end;
	    
		#{<<"sync">> := SyncedDeckcode} ->
			io:format("~nSyncing ~p's deckcode with ~p", [State, SyncedDeckcode]),
			case collaborative_decks:sync(State, SyncedDeckcode) of
				notfound ->
					{reply, {text, "Deck not found!"}, State};
				ok ->
			        {noreply, State}
				end;
		_ ->
	        {reply, {text, <<"hm">>}, State}
    end;
websocket_handle(_Data, State) ->
	io:fwrite("Unrecognized websocket message"),
	{ok, State}.

terminate(_, _, State) ->
	io:format("~n~p dropped a connection", [State]),
	collaborative_decks:drop(State).

websocket_info(_Info, State) ->
        {ok, State}.
