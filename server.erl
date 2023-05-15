-module(server).
-export([start/0, loop/2]).

start() ->
  P = spawn(server, loop, [3, 2]),
  loop(P, []).

loop(P, Primes) ->
  receive
    {worker, WorkerPid, Prime} ->
      case lists:member(Prime, Primes) of
        true ->
          io:format("Worker ~p found a duplicate prime: ~p~n", [WorkerPid, Prime]),
          P ! {terminate_worker, WorkerPid};
        false ->
          io:format("Server assigning ~p to worker ~p~n", [Prime, WorkerPid]),
          WorkerPid ! {test, Prime},
          loop(P, [Prime|Primes])
      end;
    {worker, WorkerPid, {prime, Prime}} ->
      io:format("Worker ~p found a prime: ~p~n", [WorkerPid, Prime]),
      P ! {terminate_worker, WorkerPid},
      loop(P, [Prime|Primes]);
    {terminate_worker, WorkerPid} ->
      io:format("Worker ~p terminated~n", [WorkerPid]),
      loop(P, Primes)
  end.
