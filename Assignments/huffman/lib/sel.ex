defmodule Sel do

  def sel([], acc) do acc end
  def sel([head|rest], acc) do
    min = minM([head|rest], head)
    acc = acc ++ [min]
    new = rmv([head|rest], min, [])
    sel(new, acc)
  end

  def minM([], min) do min end
  def minM([head|rest], min) do
    if(min > head) do
      minM(rest, head)
    else
      minM(rest, min)
    end
  end

  def rmv([], _, acc) do acc end
  def rmv([head|rest], rem, acc) do
    if(head == rem) do
      acc ++ rest
    else
      acc = acc ++ [head]
      rmv(rest, rem, acc)
    end
  end

  def test do
    rmv([2,3,5,0943,2,5,53,-5], 5, [])
  end

end
