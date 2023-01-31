defmodule Rec do
  def sum_n(0) do
   0
  end
  def sum_n(n) when n > -1 do
    n + sum_n(n-1)
  end

  def grid_sum(1,_) do
    1
  end
  def grid_sum(_,1) do
    1
  end
  def grid_sum(n,m) do
    grid_sum(n,m-1) + grid_sum(n-1,m)
  end

  def fact(0) do 1 end
  def fact(1) do 1 end
  def fact(n) do
    n * fact(n-1)
  end

  # def fib(0, a) do a end
  # def fib(1,a) do a + 1 end
  # def fib(n, a) do (n-1)

  def fac(1,a) do a end
  def fac(n,a) do fac(n-1, a*n) end

  def test do
    IO.inspect(sum_n(3))
    IO.inspect(grid_sum(2,2))
    IO.inspect(fact(10))
    IO.inspect(fac(6,1))
  end
end
