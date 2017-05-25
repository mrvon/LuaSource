defmodule Todo.List do
  defstruct auto_id: 1, entries: Map.new

  def new() do
    %Todo.List{}
  end

  def add_entry(
    %Todo.List{auto_id: auto_id, entries: entries} = todo_list,
    entry
  ) do
    # Set the new entry's id
    entry = Map.put(entry, :id, auto_id)
    # Adds the new entry the entries list
    new_entries = Map.put(entries, auto_id, entry)
    # Updates the struct
    %Todo.List{ todo_list |
      auto_id: auto_id + 1,
      entries: new_entries
    }
  end

  def update_entry(
    %Todo.List{entries: entries} = todo_list,
    entry_id,
    updater_fun
  ) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def update_entry(
    todo_list,
    %{} = new_entry
  ) do
    update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
  end

  def delete_entry(
    %Todo.List{entries: entries} = todo_list,
    entry_id
  ) do
    case entries[entry_id] do
      nil -> todo_list
      _ ->
        new_entries = Map.delete(entries, entry_id)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def entries(
    %Todo.List{entries: entries},
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

