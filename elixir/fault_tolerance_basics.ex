# 1. A runtime error has a type, which can be :error, :exit, or :throw.
# 2. A runtime error also has a value, which can be any arbitrary term.
# 3. If a runtime error isn’t handled, the corresponding process will terminate.
try_helper = fn(fun) ->
  try do
    fun.()
    IO.puts "No error."
  catch type, value ->
    IO.puts "Error\n #{inspect type}\n #{inspect value}"
  end
end

try_helper.(fn() ->
  raise("Something went wrong")
end)

try_helper.(fn() ->
  throw("Thrown value")
end)

try_helper.(fn() ->
  exit("I'm done")
end)

IO.inspect "--------------------------"

# Linking processes
# A basic primitive for detecting a process crash is the concept of links. If
# two processes are linked, and one of them terminates, the other process
# receives an exit signal -- a notification that a process has crashed.
#
# One link connects exactly two processes and is always bidirectional. To create
# a link, you can use Process.link/1, which connects the current process with
# another. More often, a link a created when you start a process. You can do
# this by using spawn_link/1, which spawns a process and links it to the current
# one.

# spawn(fn() ->
#   spawn_link(fn() ->
#     :timer.sleep(1)
#     IO.puts "Process 2 finished"
#   end)

#   raise("Something went wrong")
# end)

# Trapping exits
# 
# spawn(fn ->
#   Process.flag(:trap_exit, true)
#   spawn_link(fn -> raise("Something went wrong") end)
#   receive do
#     msg -> IO.inspect(msg)
#   end
# end)

# Monitor
# Sometimes you need to connect two processes A and B in such a way that process
# A is notified when B terminates, but not the other way around. In such cases,
# you can use a monitor, which is something like a unidirectional link.
# 
#   monitor_ref = Process.monitor(target_pid)
# 
# If you want to, you can also stop the monitor by calling
# 
#   Process.demonitor(monitor_ref).
# 
target_pid = spawn(fn() ->
  :timer.sleep(1)
end)

Process.monitor(target_pid)

receive do
  msg ->
    IO.inspect msg
end
