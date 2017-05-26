defmodule TodoTest do
  use ExUnit.Case

  test "Server" do
    {:ok, supervisor} = Todo.Supervisor.start_link()
    IO.puts("Supervisor pid: #{inspect supervisor}")

    bobs_server = Todo.Cache.server_process("Bob's list")
    Todo.Server.entries(bobs_server, {2013, 12, 19})
    |> IO.inspect()

    address = Process.whereis(:todo_cache)
    IO.puts("Todo Cache pid: #{inspect address}")

    # kill the process, (async)
    Process.whereis(:todo_cache)
    |> Process.exit(:kill)

    # wait a minute
    :timer.sleep(1000)

    # address has changed
    address = Process.whereis(:todo_cache)
    IO.puts("Todo Cache pid: #{inspect address}")

    bobs_server = Todo.Cache.server_process("Bob's list")
    Todo.Server.entries(bobs_server, {2013, 12, 19})
    |> IO.inspect()
  end
end
