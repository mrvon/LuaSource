defmodule Todo.Supervisor do
  use Supervisor

  def init(_) do
    processes = [worker(Todo.Cache, [])]
    supervise(processes, strategy: :one_for_one)
  end

  def start_link() do
    Supervisor.start_link(__MODULE__, nil)
  end
end
