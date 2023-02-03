defmodule Hanoi do
  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n-1, from, to, aux) ++ # move tower of size n-1 ....
    [{:move, from, to}] ++ # [ move one disc ... ] ++
    hanoi(n-1, aux, from ,to) # move tower of size n-1 ...
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
