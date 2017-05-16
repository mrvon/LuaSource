defmodule TodoList do
  def new() do
    Map.new()
  end

   def add_entry(todo_list, date, title) do
     Map.update(
      todo_list,
      date,
      [title], # inital value
      fn(titles) -> # updater lambda
        [title | titles]
      end
     )
   end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end

todo_list =
  TodoList.new
  |> TodoList.add_entry({2013, 12, 19}, "Dentist")
  |> TodoList.add_entry({2013, 12, 20}, "Shopping")
  |> TodoList.add_entry({2013, 12, 19}, "Movies")

TodoList.entries(todo_list, {2013, 12, 19})
TodoList.entries(todo_list, {2013, 12, 18})

IO.inspect(todo_list)
