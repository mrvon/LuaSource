# Generic Server
defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn() ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(
          request,
          current_state
        )
        send(caller, {:response, response})
        loop(callback_module, new_state)
      {:cast, request} ->
        new_state = callback_module.handle_cast(
          request,
          current_state
        )
        loop(callback_module, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} ->
        response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end
end

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
    ServerProcess.start(TodoServer)
  end

  def init() do
    TodoList.new()
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  def handle_cast({:update_entry, entry_id, updater_fun}, todo_list) do
    TodoList.update_entry(todo_list, entry_id, updater_fun)
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    TodoList.delete_entry(todo_list, entry_id)
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end

  def add_entry(server_pid, new_entry) do
    ServerProcess.cast(server_pid, {:add_entry, new_entry})
  end

  def update_entry(server_pid, entry_id, updater_fun) do
    ServerProcess.cast(server_pid, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(server_pid, entry_id) do
    ServerProcess.cast(server_pid, {:delete_entry, entry_id})
  end

  def entries(server_pid, date) do
    ServerProcess.call(server_pid, {:entries, date})
  end
end

# Test code
todo_server = TodoServer.start()

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
