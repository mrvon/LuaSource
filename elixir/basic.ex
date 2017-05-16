# pipeline
-5
|> abs
|> Integer.to_string
|> IO.inspect

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

IO.inspect(Calculator.sum(1, 1))
IO.inspect(Calculator.sum(10))

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
IO.inspect(TestPrivate.double(3))
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

IO.inspect(Circle.area(1))
IO.inspect(Circle.circumference(1))

# Tuple
person = {"Bob", 25}
IO.puts(elem(person, 0))
IO.puts(elem(person, 1))
# put_elem doesn't modify the tuple. It returns the new version, keeping the old
# one intact.
older_person = put_elem(person, 1, 26)
IO.inspect(person)
IO.inspect(older_person)
# rebound
person = put_elem(person, 1, 26)
IO.inspect(person)

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
IO.inspect(prime_numbers)
# concatenates two list
new_list = [1, 2, 3] ++ [4, 5]
IO.inspect(new_list)

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

IO.inspect("list_1")
IO.inspect(list_1)
IO.inspect("list_2")
IO.inspect(list_2)
IO.inspect("list_3")
IO.inspect(list_3)
IO.inspect("list_4")
IO.inspect(list_4)
IO.inspect("list_5")
IO.inspect(list_5)
# to get the head of the list
IO.inspect(hd(list_5))
# to get the tail of the list
IO.inspect(tl(list_5))

# knowing the recursive nature of the list, it's simple and efficient to push
# a new element to the top of the list.
a_list = [5, :value, true]
new_list = [:new_element | a_list]
IO.inspect(new_list)
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
IO.inspect(bob)
IO.inspect(next_years_bob)
# but you can only modify values that already exist in the map.

# to insert a new key-value pair (or modify the existing one), you can use
# the Map.put/3 function
bob_2 = Map.put(bob, :salary, 50000)
IO.inspect(bob_2)

# first-class function, a function is a first-class citizen in Elixir.
square = fn(x) ->
  x * x
end
# The motivation behind the dot operator is to make the code more explicit.
IO.inspect(square.(16))
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

# IO lists are useful when you need to incrementally build a stream of bytes.
# Lists usually aren't good in this case, because appending to a list is an O(n)
# operation. In contrast, appending to an IO list is O(1), because you can use
# nesting.

iolist = [[['H', 'e'], "llo,"], " worl", "d!"]
IO.puts(iolist)

iolist = []
iolist = [iolist, "This"]
iolist = [iolist, " is"]
iolist = [iolist, " an"]
iolist = [iolist, " IO list."]

IO.puts(iolist)

# Here, you append to an IO list by creating a new list with two elements: a
# previous version of the IO list and the suffix that is appended. Each such
# operation is O(1), so this is performant.

# ------------------------------------------------------------------------------

# Pattern matching
person = {"Bob", 25}

# Matching Tuples
{name, age} = person
IO.puts(name)
IO.puts(age)

{date, time} = :calendar.local_time
{year, month, day} = date
{hour, minute, second} = time

IO.puts(year)

person_2 = {:person, "Dennis", 25}
{:person, name, age} = person_2

IO.puts(name)

# anonymous variable
{_, time} = :calendar.local_time
{_, {hour, _, _}} = :calendar.local_time
IO.puts(hour)

# pin operator
expected_name = "Bob"
{^expected_name, _} = {"Bob", 25}
# Error
# {^expected_name, _} = {"Alice", 25}

# Matching lists
first = 1

[first, second, third] = [1, 2, 3]
[1,     second, third] = [1, 2, 3] # the first element must be 1.
[first, first, first]  = [1, 1, 1] # All elements must have the same value 
[first, second, _]     = [1, 2, 3] # You don't care about the third element
[^first, second, _]    = [1, 2, 3] # The first element must have the same value as the variable first

[head | tail] = [1, 2, 3]

[min | _] = Enum.sort([3, 2, 1])
IO.puts(min)

# Matching maps
%{name: name, age: age} = %{name: "Bob", age: 25}
IO.puts(name)
IO.puts(age)

# when matching a map, the left-side pattern doesn't need to contain all the
# keys from the right-side term.
%{age: age} = %{name: "Bob", age: 30}
IO.puts(age)

# Matching with functions
defmodule Rect do
  def area({a, b}) do
    a * b
  end
end

IO.puts(Rect.area({3, 4}))

# Multiclause function
defmodule Geometry do
  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:square, a}) do
    a * a
  end

  def area({:circle, r}) do
    3.14 * r * r
  end

  def area(unknown) do
    {:error, {:unknown_shape, unknown}}
  end
end

# For this to work correctly, it’s important to place the clauses in the
# appropriate order. The runtime tries to select the clauses using the order in
# the source code. If the area(unknown) clause was defined first, you would
# always get the error result.

IO.inspect(Geometry.area({:rectangle, 4, 5}))
IO.inspect(Geometry.area({:square, 5}))
IO.inspect(Geometry.area({:circle, 4}))
IO.inspect(Geometry.area({:triangle, 1, 2, 3}))

# Multiclause lambda

test_num = fn
  x when is_number(x) and x < 0 ->
    :negative
  0 ->
    :zero
  x when is_number(x) and x > 0 ->
    :positive
end

IO.inspect(test_num.(-1))
IO.inspect(test_num.(0))
IO.inspect(test_num.(1))

# # Conditionals

# Branching with multiclause functions
defmodule TestNum do
  def test(x) when x < 0, do: :negative
  def test(0), do: :zero
  def test(x) when x > 0, do: :positive
end

IO.puts(TestNum.test(-1))
IO.puts(TestNum.test(0))
IO.puts(TestNum.test(1))

defmodule TestList do
  def empty?([]), do: true
  def empty?([_ | _]), do: false
end

IO.puts(TestList.empty?([1,2]))
IO.puts(TestList.empty?([]))

defmodule Polymorphic do
  def double(x) when is_number(x), do: 2 * x
  def double(x) when is_binary(x), do: x <> x
end

IO.puts(Polymorphic.double(3))
IO.puts(Polymorphic.double("Jar"))

# Recursive implementation of a factorial, based on multiclause
defmodule Fact do
  def fact(0), do: 1
  def fact(n), do: n * fact(n - 1)
end

IO.puts(Fact.fact(1))
IO.puts(Fact.fact(5))

defmodule ListHelper do
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
end

IO.puts(ListHelper.sum([]))
IO.puts(ListHelper.sum([1, 2, 3]))

# Classical branching constructs
# IF and UNLESS
defmodule TestIf do
  def max(a, b) do
    if a >= b, do: a, else: b
  end
end

IO.inspect(TestIf.max(1024, 1025))

defmodule TestUnless do
  def min(a, b) do
    unless a >= b, do: a, else: b
  end
end

IO.inspect(TestUnless.min(1024, 1025))

# COND
# The COND marco can be thought of as equivalent to an if-else-if pattern
# cond do
#   expression_1 ->
#     ...
#   expression_2 ->
#     ...
#   ...
# end 
defmodule TestCond do
  def max(a, b) do
    cond do
      a >= b ->a
      true -> b
    end
  end
end

IO.inspect(TestCond.max(1025, 1026))

# CASE
# case expression do
#   pattern_1 ->
#     ...
#   pattern_2 ->
#     ...
#   ...
# end

defmodule TestCase do
  def max(a, b) do
    case a >= b do
      true -> a
      false -> b
    end
  end
end

IO.inspect(TestCase.max(1026, 1027))

defmodule NaturalNums do
  def print(n) when is_float(n) or n <= 0 do
  end

  def print(1) do
    IO.puts(1)
  end

  def print(n) when n > 1 do
    print(n - 1)
    IO.puts(n)
  end
end

NaturalNums.print(3)
NaturalNums.print(0)
NaturalNums.print(-1)
NaturalNums.print(3.4)

# Tail-recursive version of ListHelper
defmodule ListHelper2 do
  def sum(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []) do
    current_sum
  end

  defp do_sum(current_sum, [head | tail]) do
    new_sum = head + current_sum
    do_sum(new_sum, tail)
  end
end

IO.puts(ListHelper2.sum([1, 2, 3]))

defmodule Practice do
  def list_len([]) do
    0
  end

  def list_len([_ | tail]) do
    1 + list_len(tail)
  end

  defp list_len_t(l, []) do
    l
  end

  defp list_len_t(l, [_ | tail]) do
    list_len_t(l+1, tail)
  end

  # tail-recursive version
  def list_len_tr(list) do
    list_len_t(0, list)
  end

  def range(from, to) when from > to do
  end

  # tail-recursive version
  def range(from, to) do
    IO.puts(from)
    range(from+1, to)
  end

  defp positive_t(list, []) do
    Enum.reverse(list)
  end

  defp positive_t(list, [head | tail]) when head > 0 do
    positive_t([head | list], tail)
  end

  defp positive_t(list, [head | tail]) when head <= 0 do
    positive_t(list, tail)
  end

  def positive(list) do
    positive_t([], list)
  end
end

IO.inspect(Practice.list_len([1, 2, 3, 4]))
IO.inspect(Practice.list_len_tr([1, 2, 3, 4]))
Practice.range(-5, -1)
IO.inspect(Practice.positive([-1, 2, -3, 4, 5, 9]))

# High order functions
# A higher-order function is a fancy name for a function that takes functions
# as its input and/or returns functions.

Enum.each(
  [1, 2, 3],
  fn(x) -> IO.puts(x) end
)

Enum.map(
  [1, 2, 3],
  fn(x) -> 2 * x end
)

Enum.filter(
  [1, 2, 3],
  fn(x) -> rem(x, 2) == 1 end
)

Enum.filter(
  [1, 2, 3],
  &(rem(&1, 2) == 1)
)

Enum.reduce(
  [1, 2, 3],
  0,
  fn(element, sum) -> element + sum end
)

# Multiclause lambda
Enum.reduce(
  [1, "not a number", 2, :x, 3],
  0,
  fn
    element, sum when is_number(element) ->
      sum + element
    _, sum -> sum
  end
)

defmodule NumHelper do
  def sum_nums(enumerable) do
    Enum.reduce(enumerable, 0, &add_num/2)
  end

  defp add_num(num, sum) when is_number(num) do
    sum + num
  end

  defp add_num(_, sum) do
    sum
  end
end

IO.inspect(NumHelper.sum_nums([1, 2, 3]))

# Immutable hierarchical updates
todo_list = [
  {1, %{date: {2013, 12, 19}, title: "Dentist"}},
  {2, %{date: {2013, 12, 20}, title: "Shopping"}},
  {3, %{date: {2013, 12, 19}, title: "Movies"}},
]
|> Enum.into(Map.new)

IO.inspect(todo_list)

# Hierarchical update
todo_list = put_in(todo_list[3][:title], "Theater")

IO.inspect(todo_list)

# Iterative updates
