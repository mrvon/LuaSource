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

IO.puts(Geometry.area({:rectangle, 4, 5}))
IO.puts(Geometry.area({:square, 5}))
IO.puts(Geometry.area({:circle, 4}))
Geometry.area({:triangle, 1, 2, 3})

# Multiclause lambda

test_num = fn
  x when is_number(x) and x < 0 ->
    :negative
  0 ->
    :zero
  x when is_number(x) and x > 0 ->
    :positive
end

IO.puts(test_num.(-1))
IO.puts(test_num.(0))
IO.puts(test_num.(1))

# Conditionals

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
defmodule TestIf do
  def max(a, b) do
    if a >= b, do: a, else: b
  end
end

defmodule TestUnless do
  def min(a, b) do
    unless a >= b, do: a, else: b
  end
end

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
