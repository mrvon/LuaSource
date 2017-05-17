defmodule Calculator do
  def start() do
    spawn(fn() ->
      loop(0)
    end)
  end

  defp loop(cur_value) do
    new_value = receive do
      message ->
        process_message(cur_value, message)
    end
    loop(new_value)
  end

  defp process_message(cur_value, {:value, caller}) do
    send(caller, {:response, cur_value})
    cur_value
  end

  defp process_message(cur_value, {:add, value}) do
    cur_value + value
  end

  defp process_message(cur_value, {:sub, value}) do
    cur_value - value
  end

  defp process_message(cur_value, {:mul, value}) do
    cur_value * value
  end

  defp process_message(cur_value, {:div, value}) do
    cur_value / value
  end

  defp process_message(cur_value, invalid_request) do
    IO.puts "invalid request #{inspect invalid_request}"
    cur_value
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})
    receive do
      {:response, value} ->
        value
    end
  end

  def add(server_pid, value) do
    send(server_pid, {:add, value})
  end

  def sub(server_pid, value) do
    send(server_pid, {:sub, value})
  end

  def mul(server_pid, value) do
    send(server_pid, {:mul, value})
  end

  def div(server_pid, value) do
    send(server_pid, {:div, value})
  end
end

c_pid = Calculator.start()

Calculator.value(c_pid)
|> IO.inspect

Calculator.add(c_pid, 10)
Calculator.sub(c_pid, 5)
Calculator.mul(c_pid, 3)
Calculator.div(c_pid, 5)

Calculator.value(c_pid)
|> IO.inspect
