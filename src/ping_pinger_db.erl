-module(ping_pinger_db).

-include("records.hrl").
-include("defaults.hrl").
-include_lib("deps/emysql/include/emysql.hrl").

-export([find/1,create/5,all/1,get_subscriptions/4]).

-spec find(pos_integer()) -> notfound | #pinger{}.
find(Id) ->
  Result = ping_db:find(?PINGER_TABLE,[{where,[{id,integer_to_list(Id)}]}]),
  [Pinger|[]] = emysql_util:as_record( Result, pinger, record_info(fields, pinger)),
  Pinger.

-spec create(string(),string(),pos_integer(),string(),pos_integer()) -> integer().
create(Name,Type,UserId,EndPoint,Frequency) -> 
  Result = ping_db:create(?PINGER_TABLE,[{name,Name},{type,Type},{user_id,integer_to_list(UserId)},{end_point,EndPoint},{frequency,Frequency}]).

-spec all(list()) -> [#user{}].
all(Options) -> 
Result = ping_db:find(?PINGER_TABLE,Options),
  emysql_util:as_record(
		Result, user, record_info(fields, user)).

get_subscriptions(Type,PingerId,pinger_down,DownTime) ->
  Query = "SELECT u."++atom_to_list(Type)++" FROM users u,subscriptions s WHERE u.id = s.user_id AND s.type = '"++atom_to_list(Type)++"' AND s.pinger_id = "++integer_to_list(PingerId)++" AND s.down_time <= "++integer_to_list(DownTime),
  R = ping_db:execute(list_to_binary(Query)),
  lists:flatten(R#result_packet.rows);
get_subscriptions(Type,PingerId,pinger_up,_DownTime) ->
  Query = "SELECT u."++atom_to_list(Type)++" FROM users u,subscriptions s WHERE u.id = s.user_id AND s.type = '"++atom_to_list(Type)++"' AND s.pinger_id = "++integer_to_list(PingerId)++ " AND s.notify_when_up = true",
  R = ping_db:execute(list_to_binary(Query)),
  lists:flatten(R#result_packet.rows).