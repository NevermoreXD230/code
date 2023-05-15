-module(worker).
-export([start/1, loop/2]).

start(ServerPid) ->
  P = spawn(worker, loop, [ServerPid, 0]),
  loop(ServerPid, P).

loop(ServerPid, Prime) ->
  receive
    {test, Prime} ->
      case fermat:is_prime(Prime) of
        true ->
          ServerPid ! {worker, self(), {prime, Prime}};
          loop(ServerPid, 0);
        false ->
          ServerPid ! {worker, self(), Prime},
          loop(ServerPid, Prime + 2)
      end;
    {terminate, ServerPid} ->
      exit(normal)
  end.
