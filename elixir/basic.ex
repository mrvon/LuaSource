# pipeline
-5
|> abs
|> Integer.to_string
|> IO.puts

# function arity
defmodule Calculator do
  # def sum(a) do
  #   sum(a, 0)
  # end

  # def sum(a, b) do
  #   a + b
  # end

  # same as above two definition
  def sum(a, b \\ 0) do
    a + b
  end
end

IO.puts(Calculator.sum(1, 1))
IO.puts(Calculator.sum(10))

# function visibility
# exported function and private function
defmodule MyModule do
  def fun(a, b \\ 1, c, d \\ 2) do
    a + b + c + d
  end
end

defmodule TestPrivate do
  # exported function
  def double(a) do
    sum(a, a)
  end

  # private function
  defp sum(a, b) do
    a + b
  end
end

# OK
IO.puts(TestPrivate.double(3))
# Failed
# TestPrivate.sum(3, 4)

# import and aliases
defmodule MyModule2 do
  import IO

  def my_function do
    puts "Calling imported function."
  end
end

MyModule2.my_function()

defmodule MyModule3 do
  alias IO, as: MyIO

  def my_function do
    MyIO.puts "Calling imported function."
  end
end

MyModule3.my_function()

# module attributes
defmodule Circle do
  @moduledoc "Implements basic circle functions"

  @pi 3.14159

  @doc "Computes the area of a circle"
  @spec area(number) :: number
  def area(r) do
    @pi * r * r
  end

  @doc "Computes the circumference of a circle"
  @spec circumference(number) :: number
  def circumference(r) do
    2 * @pi * r
  end
end

IO.puts(Circle.area(1))
IO.puts(Circle.circumference(1))

# Tuple
person = {"Bob", 25}
IO.puts(elem(person, 0))
IO.puts(elem(person, 1))
# put_elem doesn't  modify the tuple. It returns the new version, keeping the
# old one intact.
older_person = put_elem(person, 1, 26)
IO.puts(elem(person, 1))
IO.puts(elem(older_person, 1))
# rebound
person = put_elem(person, 1, 26)
IO.puts(elem(person, 1))

# List
# List in erlang are used to manage dynamic, variable-sized collections of data.
prime_numbers = [1, 2, 3, 5, 7]
# O(n) complexity
IO.puts(length(prime_numbers))
# To get an element of a list
IO.puts(Enum.at(prime_numbers, 4))
# check whether a list contains a particular element
IO.puts(5 in prime_numbers)
IO.puts(4 in prime_numbers)
# modifies the element at a certain place
new_primes = List.replace_at(prime_numbers, 0, 11)
IO.puts(Enum.at(new_primes, 0))
prime_numbers = List.replace_at(prime_numbers, 0, 11)
IO.puts(Enum.at(prime_numbers, 0))
# insert a new element at the specified position
prime_numbers = List.insert_at(prime_numbers, 4, 1)
# to append to the end
prime_numbers = List.insert_at(prime_numbers, -1, 1)
# concatenates two list
new_list = [1, 2, 3] ++ [4, 5]

# recursive list definition
# a list can be represented by a pair(head, tail),
# where head is the first element of the list and tail "points"
# to the (head, tail) pair of the remaining element.

# a_list = [head, tail]

# head can be any type of data, whereas tail is itself a list.
# If tail is an empty list, it indicates the end of the entire list.

list_1 = [1 | []]
list_2 = [1 | [2 | []]]
list_3 = [1 | [2]]
list_4 = [1 | [2, 3, 4]]
list_5 = [1 | [2 | [3 | [4 | []]]]]

# to get the head of the list
hd(list_5)
# to get the tail of the list
tl(list_5)

# knowing the recursive nature of the list, it's simple and efficient to push
# a new element to the top of the list.
a_list = [5, :value, true]
new_list = [:new_element | a_list]
# construction of the new_list is an O(1) operation, and no memory copying
# occurs, the tail of the new_list is the a_list!

# Maps
bob = %{name: "Bob", age: 25, works_at: "Initech"}
IO.puts(bob[:name])
IO.puts(bob[:not_existent_field] == nil)
IO.puts(bob.name)
IO.puts(bob.age)
IO.puts(bob.works_at)

# modify value
next_years_bob = %{bob | age: 26, works_at: "Initrode"}
IO.puts(next_years_bob.age)
IO.puts(next_years_bob.works_at)
# but you can only modify values that already exist in the map.

# to insert a new key-value pair (or modify the existing one), you can use
# the Map.put/3 function
bob_2 = Map.put(bob, :salary, 50000)
IO.puts(bob_2.salary)

bob_2 = Dict.put(bob, :salary, 50001)
IO.puts(bob_2.salary)

# first-class function, a function is a first-class citizen in Elixir.
square = fn(x) ->
  x * x
end
# The motivation behond the dot operator is to make the code more explict.
IO.puts(square.(16))
# lambda
print_element = 
Enum.each(
  [1, 2, 3],
  fn(x) -> IO.puts(x) end
)
Enum.each(
  [1, 2, 3],
  &IO.puts/1
)
# closures
# a lambda can reference any variable from the outside scope
outside_var = 1024
my_lambda = fn() ->
  IO.puts(outside_var)
end
my_lambda.()
outside_var = 1025
my_lambda.()
