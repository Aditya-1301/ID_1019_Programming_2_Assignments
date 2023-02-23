defmodule Asynch do

  @timeout 200

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, left, right, name, ctrl) do
    spawn_link( fn->
      ref = make_ref()
      async(hunger, left, right, name, ctrl, ref)
      send(ctrl, :done)
      IO.inspect("#{name} has finished eating")
    end)
  end

  def async(0, left, right, name, ctrl, ref) do IO.inspect("--###--#{name} has finished eating--###--") end
  def async(hunger, left, right, name, ctrl, ref) do
    sleep(hunger*100)
    IO.inspect("#{name} wants to eat; hunger at #{hunger}")
    case eat(hunger, left, right, name, ctrl, ref) do
      :timeout -> async(hunger, left, right, name, ctrl, make_ref())
      :ok -> async(hunger - 1, left, right, name, ctrl, ref)
    end
  end

  def eat(hunger, left, right, name, ctrl, ref) do
    Chopstick.request(left, self(), ref)
    Chopstick.request(right, self(), ref)
    case granted(2, ref) do
      :timeout ->
        IO.inspect("#{name} doesn't get to eat this time")
        Chopstick.return(left, ref)
        Chopstick.return(right, ref)
        :timeout
      :ok ->
        IO.inspect("#{name} eats a bite")
        Chopstick.return(left, ref)
        Chopstick.return(right, ref)
        :ok
    end
  end

  def granted(0, ref) do :ok end
  def granted(n, ref) do
    receive do
       {:ok, ^ref} -> granted(n-1,ref)
       after @timeout -> :timeout
    end
  end
end
