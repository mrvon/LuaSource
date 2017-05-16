defmodule TodoList do
  def new() do
    Map.new()
  end

  def add_entry(todo_list, entry) do
    Map.update(
      todo_list,
      entry.date,
      [entry], # inital value
      fn(entries) -> # updater lambda
      [entry | entries]
      end
    )
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end

todo_list =
  TodoList.new
  |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
  |> TodoList.add_entry(%{date: {2013, 12, 20}, title: "Shopping"}) 
  |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Movies"})
TodoList.entries(todo_list, {2013, 12, 19})
TodoList.entries(todo_list, {2013, 12, 18})

IO.inspect(todo_list)
