defmodule Server do
  def start() do
    spawn(fn() ->
      loop()
    end)
  end

  def send_msg(server, message) do
    send(server, {self(), message})
    receive do
      {:response, response} -> response
    end
  end

  defp loop() do
    receive do
      {caller, msg} ->
        :timer.sleep(1000)
        send(caller, {:response, msg})
    end

    loop()
  end
end

server = Server.start()
Enum.each(1..5, fn(i) ->
  spawn(fn() ->
    IO.puts("Sending msg ##{i}")
    response = Server.send_msg(server, i)
    IO.puts("Response: #{response}")
  end)
end)

:timer.sleep(100000)
