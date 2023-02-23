defmodule Chopstick do
  def start do
    stick = spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} -> send(from, :granted); gone() # Synchronous Available
      {:request, from, ref} -> send(from, {:ok, ref}); gone(ref) #Async Available
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available() # Synchronous Gone
      :quit -> :ok
    end
  end

  def gone(ref) do
    receive do
      {:return, ^ref} -> available() # Async Gone
      :quit -> :ok
    end
  end

  def request(pid) do
    send(pid, {:request, self()})
    receive do
      :granted -> :ok
      :quit -> :ok
    end
  end

  def request(stick, timeout) do
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
      after timeout ->
        IO.inspect("Timeout")
        :no
    end
  end

  def request(stick, from, ref) do
    send(stick, {:request, from, ref})
  end

  def return(stick) do
    send(stick, :return)
  end

  def return(stick, ref) do
    send(stick, {:return, ref})
  end

  def quit(stick) do
    send(stick, :quit)
  end
end
