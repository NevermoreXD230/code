-module(fermat).
-export([is_prime/1]).

is_prime(P) ->
  R = random:uniform(P-1),
  mpow(R, P-1, P) == 1.

mpow(N, 1, _) ->
  N;
mpow(N, K, M) ->
  mpow(K rem 2, N, K, M).

mpow(0, N, K, M) ->
  X = mpow(N, K div 2, M),
  (X * X) rem M;
mpow(_, N, K, M) ->
  X = mpow(N, K - 1, M),
  (X * N) rem M.
