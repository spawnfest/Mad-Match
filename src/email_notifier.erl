%%% Author  : Marcos Almonacid
-module(email_notifier).

-behaviour(gen_event).

-include("records.hrl").

-define(PINGER_DOWN_EMAIL(Name,DownTime),[{subject,"Server Down: "++Name},
                                          {body,"The server "++Name++" has been down for "++integer_to_list(DownTime)++" minutes."}]).
-define(PINGER_UP_EMAIL(Name),[{subject,"Server is back: "++Name},
                               {body,"The server "++Name++" is up again :D."}]).

%% gen_event callbacks
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

-export([send/2]).

-record(state, {}).

-spec init([]) -> {ok,#state{}}.
init([]) ->
  {ok, #state{}}.

-spec handle_event(#event{} | term(),#state{}) -> {ok,#state{}}. 
handle_event(#event{ type = Type, pinger = Pinger, down_time = DownTime }, State) ->
  Emails = ping_pinger_db:get_subscriptions(email,Pinger#pinger.id,Type,DownTime),
  case Type of
    pinger_down ->
      DownTimeMins = trunc((DownTime/1000)/60),
      lists:foreach(fun(Email) -> send(Email,?PINGER_DOWN_EMAIL(Pinger#pinger.name,DownTimeMins)) end, Emails);
    pinger_up ->
      lists:foreach(fun(Email) -> send(Email,?PINGER_UP_EMAIL(Pinger#pinger.name)) end, Emails)
  end,
  {ok, State};
handle_event(Event, State) ->
  lager:info("email notifier, unknown event: ~p",[Event]),
  {ok, State}.

-spec handle_call(term(),#state{}) -> {ok,ok,#state{}}.
handle_call(_Request, State) ->
  Reply = ok,
  {ok, Reply, State}.

-spec handle_info(term(),#state{}) -> {ok,#state{}}.
handle_info(_Info, State) ->
  {ok, State}.

-spec terminate(term(),#state{}) -> ok.
terminate(_Reason, _State) ->
  ok.

-spec code_change(term(),#state{},term()) -> {ok,#state{}}.
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
-spec send(string(),[tuple()]) -> ok.
send(Email,[{subject,Subject},{body,Body}]) ->
  lager:debug("sending email: ~p ~p",[Email,Subject]),
  mailer:send({ping_utils:get_env(email_host), ping_utils:get_env(email_port)},
              {ping_utils:get_env(email_name),ping_utils:get_env(email_addr),ping_utils:get_env(email_pwd)},
              [Email], Subject, Body).
