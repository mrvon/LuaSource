defmodule TodoTest do
  use ExUnit.Case

  test "Server" do
    {:ok, cache} = Todo.Cache.start()

    bobs_server = Todo.Cache.server_process(cache, "bobs_list")

    Todo.Server.add_entry(
      bobs_server,
      %{date: {2013, 12, 19}, title: "Dentist"}
    )

    Todo.Server.add_entry(
      bobs_server,
      %{date: {2013, 12, 20}, title: "Shopping"}
    )

    Todo.Server.add_entry(
      bobs_server,
      %{date: {2013, 12, 19}, title: "Movies"}
    )

    Todo.Server.entries(bobs_server, {2013, 12, 19})
    |> IO.inspect()

    Todo.Server.update_entry(bobs_server, 1, fn(entry) ->
      Map.put(entry, :date, {2013, 12, 30})
    end)

    Todo.Server.entries(bobs_server, {2013, 12, 19})
    |> IO.inspect

    Todo.Server.entries(bobs_server, {2013, 12, 30})
    |> IO.inspect

    Todo.Server.delete_entry(bobs_server, 1)

    Todo.Server.entries(bobs_server, {2013, 12, 30})
    |> IO.inspect
  end
end
