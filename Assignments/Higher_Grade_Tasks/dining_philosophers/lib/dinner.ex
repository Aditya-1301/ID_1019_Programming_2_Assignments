defmodule Dinner do

  def test() do
    IO.inspect("Benchmark: #{Decimal.div(iterate(10, Decimal.new(0)),100)}")
  end

  def iterate(0, a) do a end
  def iterate(iterations, a) do
    t1 = :erlang.timestamp()
    a = Decimal.add(a, init(t1))
    iterate(iterations - 1, a)
  end

  def start() do
    t1 = :erlang.timestamp()
    spawn(fn -> init(t1) end)
  end

  def init(t1) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    n1 = :rand.uniform(15); IO.inspect("n1: #{n1}")
    n2 = :rand.uniform(15); IO.inspect("n2: #{n2}")
    n3 = :rand.uniform(15); IO.inspect("n3: #{n3}")
    n4 = :rand.uniform(15); IO.inspect("n4: #{n4}")
    n5 = :rand.uniform(15); IO.inspect("n5: #{n5}")

    # Philosopher.start(n1, c1, c2, "Arendt", ctrl)
    # Philosopher.start(n2, c2, c3, "Hypatia", ctrl)
    # Philosopher.start(n3, c3, c4, "Simone", ctrl)
    # Philosopher.start(n4, c4, c5, "Elisabeth", ctrl)
    # Philosopher.start(n5, c5, c1, "Ayn", ctrl)

    # Philosopher.start(5, c1, c2, "Arendt", ctrl)
    # Philosopher.start(5, c2, c3, "Hypatia", ctrl)
    # Philosopher.start(5, c3, c4, "Simone", ctrl)
    # Philosopher.start(5, c4, c5, "Elisabeth", ctrl)
    # Philosopher.start(5, c5, c1, "Ayn", ctrl)

    # Asynch.start(n1, c1, c2, "Arendt", ctrl)
    # Asynch.start(n2, c2, c3, "Hypatia", ctrl)
    # Asynch.start(n3, c3, c4, "Simone", ctrl)
    # Asynch.start(n4, c4, c5, "Elisabeth", ctrl)
    # Asynch.start(n5, c5, c1, "Ayn", ctrl)

    Asynch.start(5, c1, c2, "Arendt", ctrl)
    Asynch.start(5, c2, c3, "Hypatia", ctrl)
    Asynch.start(5, c3, c4, "Simone", ctrl)
    Asynch.start(5, c4, c5, "Elisabeth", ctrl)
    Asynch.start(5, c5, c1, "Ayn", ctrl)

    wait(5, [c1, c2, c3, c4, c5], t1)
  end

  def wait(0, chopsticks, t1) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    t2 = :erlang.timestamp()
    dif = :timer.now_diff(t2,t1)
    # IO.inspect("Time taken for this seed of the Dining Philosophers Problem: #{div(dif, 1_000_000)}")
    Decimal.div(dif, 1_000_000)
  end
  def wait(n, chopsticks, t1) do
    receive do
      :done ->
        wait(n - 1, chopsticks, t1)
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
