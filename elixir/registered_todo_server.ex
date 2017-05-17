defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new

  def new() do
    %TodoList{}
  end

  def add_entry(
    %TodoList{auto_id: auto_id, entries: entries} = todo_list,
    entry
  ) do
    # Set the new entry's id
    entry = Map.put(entry, :id, auto_id)
    # Adds the new entry the entries list
    new_entries = Map.put(entries, auto_id, entry)
    # Updates the struct
    %TodoList{ todo_list |
      auto_id: auto_id + 1,
      entries: new_entries
    }
  end

  def update_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id,
    updater_fun
  ) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(
    todo_list,
    %{} = new_entry
  ) do
    update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
  end

  def delete_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id
  ) do
    case entries[entry_id] do
      nil -> todo_list
      _ ->
        new_entries = Map.delete(entries, entry_id)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def entries(
    %TodoList{entries: entries},
    date
  ) do
    entries
    |> Stream.filter(fn({_, entry}) ->
      entry.date == date
    end)
    |> Enum.map(fn({_, entry}) ->
      entry
    end)
  end
end

defmodule TodoServer do
  def start() do
    spawn(fn() ->
      loop(TodoList.new())
    end)
    |> Process.register(:todo_server)
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      message ->
        process_message(todo_list, message)
    end
    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end

  defp process_message(todo_list, {:update_entry, entry_id, updater_fun}) do
    TodoList.update_entry(todo_list, entry_id, updater_fun)
  end

  defp process_message(todo_list, {:delete_entry, entry_id}) do
    TodoList.delete_entry(todo_list, entry_id)
  end

  def add_entry(new_entry) do
    send(:todo_server, {:add_entry, new_entry})
  end

  def entries(date) do
    send(:todo_server, {:entries, self(), date})
    receive do
      {:todo_entries, entries} -> entries
    after 5000 ->
      {:error, :timeout}
    end
  end

  def update_entry(entry_id, updater_fun) do
    send(:todo_server, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(entry_id) do
    send(:todo_server, {:delete_entry, entry_id})
  end
end

TodoServer.start()

TodoServer.add_entry(
  %{date: {2013, 12, 19}, title: "Dentist"}
)

TodoServer.add_entry(
  %{date: {2013, 12, 20}, title: "Shopping"}
)

TodoServer.add_entry(
  %{date: {2013, 12, 19}, title: "Movies"}
)

TodoServer.entries({2013, 12, 19})
|> IO.inspect

TodoServer.update_entry(
  1,
  &Map.put(&1, :date, {2013, 12, 30})
)

TodoServer.entries({2013, 12, 19})
|> IO.inspect

TodoServer.entries({2013, 12, 30})
|> IO.inspect

TodoServer.delete_entry(1)

TodoServer.entries({2013, 12, 30})
|> IO.inspect
