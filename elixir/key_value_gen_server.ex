defmodule KeyValueStore do
  use GenServer

  def init(_) do
    :timer.send_interval(5000, :cleanup)
    {:ok, Map.new()}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_info(:cleanup, state) do
    IO.puts "performing cleanup..."
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def start() do
    GenServer.start(KeyValueStore, nil)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end
end

{:ok, server_pid} = KeyValueStore.start()
KeyValueStore.put(server_pid, :some_key, :some_value)
KeyValueStore.get(server_pid, :some_key)
|> IO.inspect()

:timer.sleep(1000000)
