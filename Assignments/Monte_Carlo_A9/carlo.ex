defmodule MC do

  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r,2) >=  :math.pow(x,2) + :math.pow(y,2)
  end

  def round(0, _, a) do a end
  def round(k, r, a) do
    if dart(r) do
      round(k - 1, r, a + 1)
    else
      round(k - 1, r, a)
    end
  end

  def rounds(k, j, r) do
    #rounds(k, j , 0, r, 0)
    rounds(k, j , r, 0)
  end
  def rounds(0, _, t, _, a) do 4*a/t end
  def rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    pi = 4*a/t
    #:io.format(" j = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [j, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    # IO.inspect("Pi estimate = #{pi}")
    # IO.inspect("Difference from actual value of Pi = #{pi - :math.pi()}")
    rounds(k-1, j, t, r, a)
  end


  def rounds(0, n, _, a) do 4*a/n end
  def rounds(k, n, r, a) do
    a = round(n, r, a)
    n = n*2
    pi = 4*a/n
    #:io.format(" n = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [n, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    # IO.inspect("Pi estimate = #{pi}")
    # IO.inspect("Difference from actual value of Pi = #{pi - :math.pi()}")
    rounds(k-1, n, r, a)
  end

  def test do
    k = 10
    j = 10000
    # t = 0
    #n = 10000
    r = 10000
    # a = 0
    IO.puts("For 1,000 darts and same radius :#{rounds(10,1_000,1_000)}")
    IO.puts("For 10,000 darts and same radius :#{rounds(10,10_000,10_000)}")
    IO.puts("For 100,000 darts and same radius :#{rounds(10,100_000,100_000)}")
    IO.puts("For 1,000,000 darts and same radius :#{rounds(10,1_000_000,1_000_000)}")
    IO.puts("For 10,000,000 darts and same radius :#{rounds(10,10_000_000,10_000_000)}")
    IO.puts("For 40,000,000 darts and same radius :#{rounds(10,40_000_000,40_000_000)}")
    #rounds(k,n,r,a)
    #round(100_000, 5, 0)
  end
end
