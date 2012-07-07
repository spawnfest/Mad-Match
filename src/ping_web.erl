-module(ping_web).


%%
%% Exported Functions
%%
-export([start_link/2]).

%%
%% API Functions
%%
-spec start_link(string(),pos_integer()) -> {ok,pid()}.
start_link(_Host,Port) ->
  Dispatch = [
    %% {Host, list({Path, Handler, Opts})}
    {'_', [

          {[<<"api">>, '...'],    ping_web_handler_api, []},

          {[],                    ping_web_handler_static, [<<"index.html">>]},
          {['_', '...'],          ping_web_handler_static, []}
      ]
    }
  ],

  %% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
  cowboy:start_listener(ping_web_http_listener, 100,
    cowboy_tcp_transport, [{port, Port}],
    cowboy_http_protocol, [{dispatch, Dispatch}]
  ).

%%
%% Local Functions
%%

