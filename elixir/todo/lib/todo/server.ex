defmodule Todo.Server do
  use GenServer

  def init(_) do
    {:ok, Todo.List.new()}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:update_entry, entry_id, updater_fun}, todo_list) do
    {:noreply, Todo.List.update_entry(todo_list, entry_id, updater_fun)}
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  def start() do
    GenServer.start(Todo.Server, nil)
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
# {:ok, todo_server} = Todo.Server.start()

# Todo.Server.add_entry(
#   todo_server,
#   %{date: {2013, 12, 19}, title: "Dentist"}
# )

# Todo.Server.add_entry(
#   todo_server,
#   %{date: {2013, 12, 20}, title: "Shopping"}
# )

# Todo.Server.add_entry(
#   todo_server,
#   %{date: {2013, 12, 19}, title: "Movies"}
# )

# Todo.Server.entries(todo_server, {2013, 12, 19})
# |> IO.inspect

# Todo.Server.update_entry(
#   todo_server,
#   1,
#   &Map.put(&1, :date, {2013, 12, 30})
# )

# Todo.Server.entries(todo_server, {2013, 12, 19})
# |> IO.inspect

# Todo.Server.entries(todo_server, {2013, 12, 30})
# |> IO.inspect

# Todo.Server.delete_entry(todo_server, 1)

# Todo.Server.entries(todo_server, {2013, 12, 30})
# |> IO.inspect
