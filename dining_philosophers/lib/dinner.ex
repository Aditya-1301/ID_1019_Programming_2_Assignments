defmodule Dinner do
  def start(), do: spawn(fn -> init() end)

  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    n1 = :rand.uniform(15); IO.inspect(n1)
    n2 = :rand.uniform(15); IO.inspect(n2)
    n3 = :rand.uniform(15); IO.inspect(n3)
    n4 = :rand.uniform(15); IO.inspect(n4)
    n5 = :rand.uniform(15); IO.inspect(n5)
    Philosopher.start(n1, c1, c2, "Arendt", ctrl)
    Philosopher.start(n2, c2, c3, "Hypatia", ctrl)
    Philosopher.start(n3, c3, c4, "Simone", ctrl)
    Philosopher.start(n4, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(n5, c5, c1, "Ayn", ctrl)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end
end

#Arent -> done
#Hypatia -> done
#Simone -> done
#Elisabeth ->
#Ayn ->
