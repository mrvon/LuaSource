run_query = fn(query_def) ->
  :timer.sleep(1000)
  "#{query_def} result"
end

async_query = fn(query_def) ->
  caller = self()
  spawn(fn ->
    send(caller, {:query_result, run_query.(query_def)})
  end)
end

IO.inspect(run_query)
IO.inspect(async_query)

Enum.each(1..5, fn(n) ->
  async_query.("QUERY #{n}")
end)

get_result = fn() ->
  receive do
    {:query_result, result} -> result
  end
end

results = Enum.map(1..5, fn(_) ->
  get_result.()
end)

IO.inspect(results)
