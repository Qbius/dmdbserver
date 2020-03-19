-module(ws).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

-record(ws_state, {wut}).

init(Req, _State) ->
	{cowboy_websocket, Req, #ws_state{wut = ""}}.

websocket_init(State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{ok, State}.

websocket_handle({text, Msg}, State) ->
	case jsx:decode(Msg, [return_maps]) of
	    #{<<"jazda">> := Wut} ->
		    {reply, {text, jsx:encode(#{<<"ale">> => Wut})}, State#ws_state{wut = Wut}};
	    _ ->
	        {reply, {text, <<"hm">>}, State}
    end;
websocket_handle(_Data, State) ->
	{ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{reply, {text, Msg}, State};
websocket_info(_Info, State) ->
        {ok, State}.