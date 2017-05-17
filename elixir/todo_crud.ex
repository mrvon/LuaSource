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

todo_list = 
  TodoList.new
  |> TodoList.add_entry(
    %{date: {2013, 12, 19}, title: "Dentist"}
  )
  |> TodoList.add_entry(
    %{date: {2013, 12, 20}, title: "Shopping"}
  )
  |> TodoList.add_entry(
    %{date: {2013, 12, 19}, title: "Movies"}
  )

IO.inspect(TodoList.entries(todo_list, {2013, 12, 19}))

todo_list = TodoList.update_entry(
  todo_list,
  1,
  &Map.put(&1, :date, {2013, 12, 30})
)

IO.inspect(TodoList.entries(todo_list, {2013, 12, 19}))
IO.inspect(TodoList.entries(todo_list, {2013, 12, 30}))

todo_list = TodoList.delete_entry(todo_list, 1)
IO.inspect(TodoList.entries(todo_list, {2013, 12, 30}))
