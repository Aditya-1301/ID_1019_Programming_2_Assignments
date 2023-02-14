defmodule Hanoi do
  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n-1, from, to, aux) ++ # move tower of size n-1 ....
    [{:move, from, to}] ++ # [ move one disc ... ] ++
    hanoi(n-1, aux, from ,to) # move tower of size n-1 ...
  end

  # def test()  do
  #   IO.inspect(length(Hanoi.hanoi(2,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(3,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(4,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(5,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(6,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(7,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(8,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(9,:a,:b,:c)))
  #   IO.inspect(length(Hanoi.hanoi(10,:a,:b,:c)))
  # end
  def test (0) do "0 -> 0" end
  def test (n) do
    IO.inspect("#{n} -> #{length(Hanoi.hanoi(n,:a,:b,:c))}")
    test(n-1)
  end
end

# [
# {:move, :a, :c},
# {:move, :a, :b},
# {:move, :a, :c},
# {:move, :a, :c},
# {:move, :a, :c},
# {:move, :b, :c},
# {:move, :a, :c}
# ]


# [
#   {:move, :a, :c},
#   {:move, :a, :b},
#   {:move, :c, :b},
#   {:move, :a, :c},
#   {:move, :b, :a},
#   {:move, :b, :c},
#   {:move, :a, :c}
#   ]
