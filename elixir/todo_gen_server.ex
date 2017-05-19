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
  use GenServer

  def init(_) do
    {:ok, TodoList.new()}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:update_entry, entry_id, updater_fun}, todo_list) do
    {:noreply, TodoList.update_entry(todo_list, entry_id, updater_fun)}
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, TodoList.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end

  def start() do
    GenServer.start(TodoServer, nil)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def update_entry(pid, entry_id, updater_fun) do
    GenServer.cast(pid, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete_entry, entry_id})
  end
end

# Test code
{:ok, todo_server} = TodoServer.start()

TodoServer.add_entry(
  todo_server,
  %{date: {2013, 12, 19}, title: "Dentist"}
)

TodoServer.add_entry(
  todo_server,
  %{date: {2013, 12, 20}, title: "Shopping"}
)

TodoServer.add_entry(
  todo_server,
  %{date: {2013, 12, 19}, title: "Movies"}
)

TodoServer.entries(todo_server, {2013, 12, 19})
|> IO.inspect

TodoServer.update_entry(
  todo_server,
  1,
  &Map.put(&1, :date, {2013, 12, 30})
)

TodoServer.entries(todo_server, {2013, 12, 19})
|> IO.inspect

TodoServer.entries(todo_server, {2013, 12, 30})
|> IO.inspect

TodoServer.delete_entry(todo_server, 1)

TodoServer.entries(todo_server, {2013, 12, 30})
|> IO.inspect
