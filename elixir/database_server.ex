defmodule DatabaseServer do
  def start() do
    spawn(fn() ->
      loop()
    end)
  end

  defp loop() do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    end
    loop()
  end

  defp run_query(query_def) do
    :timer.sleep(2000)
    "#{query_def} result"
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result() do
    receive do
      {:query_result, result} -> result
    after 5000 ->
      {:error, :timeout}
    end
  end
end

# server_pid = DatabaseServer.start()
# DatabaseServer.run_async(server_pid, "query 1")
# IO.inspect(DatabaseServer.get_result())
# DatabaseServer.run_async(server_pid, "query 2")
# IO.inspect(DatabaseServer.get_result())

pool = 
  1..100
  |> Enum.map(fn(_) ->
    DatabaseServer.start()
  end)

1..5
|> Enum.each(fn(query_def) ->
  server_pid = Enum.at(pool, :rand.uniform(100) - 1)
  DatabaseServer.run_async(server_pid, query_def)
end)

1..5
|> Enum.map(fn(_) ->
  DatabaseServer.get_result()
  |> IO.inspect
end)

:timer.sleep(10000)
