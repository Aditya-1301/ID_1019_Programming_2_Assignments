defmodule Philosopher do
  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn->
      sleep(hunger * 100)
      IO.inspect("#{name} wants to eat")
      waiting(hunger, left, right, name, ctrl)
    end)
  end

  def eating(hunger, left, right, name, ctrl) do
    IO.inspect("#{name} eats a bite")
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(hunger - 1, left, right, name, ctrl)
  end

  def dreaming(hunger, left, right, name, ctrl) do
    IO.inspect("#{name} is dreaming")
    sleep(hunger*100)
    case hunger do
      0 -> send(ctrl, :done)
      _ ->
        IO.inspect("#{name} has woken up and is now waiting for her sticks to eat more")
        waiting(hunger,left,right,name,ctrl)
    end
  end

  def waiting(hunger, left, right, name, ctrl) do
    IO.inspect("#{name} is now waiting with hunger:#{hunger}")
    case Chopstick.request(left, 200) do
      :ok ->
        IO.inspect("#{name} has acquired the left chopstick")
        case Chopstick.request(right, 200) do
          :ok ->
            IO.inspect("#{name} has acquired both chopsticks")
            eating(hunger, left, right, name, ctrl)
        end
    end
  end
end
