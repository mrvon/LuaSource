-module(test).
-export([test/0]).

for(Max, Max, F) ->
    F(Max);
for(I, Max, F) ->
    F(I),
    for(I+1, Max, F).

test() ->
    for(1, 10, fun(X) -> io:format("~w~n", [X]) end).
