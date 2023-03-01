defmodule Train do

  def take(train, n) do
    take(train, n, [])
  end
  def take([], _, acc) do
    acc
  end
  def take(_, 0, acc) do
    acc
  end
  def take([head|rest], n, acc) when n > 0 do
    acc = acc ++ [head]
    n = n - 1
    take(rest, n, acc)
  end

  def drop(train, n) do
    drop(train, n, [])
  end
  def drop([], _, acc) do
    acc
  end
  def drop(_, 0, acc) do
    acc
  end
  def drop([head|rest], n, acc) when n > 0 do
    drop(rest, n - 1, rest)
  end

  def append(train1, train2) do
    train1 ++ train2
  end

  def member([], y) do
    false
  end
  def member([head|rest], y) do
    if(head == y) do
      true
    else
      member(rest,y)
    end
  end

  def position(train, y)do
    pos(train, y, 1)
  end
  def pos([], _, acc) do acc end
  def pos([head|rest], y, acc) do
    if(head == y) do
      acc
    else
      pos(rest, y, acc + 1)
    end
  end

  def split(train, y) do
    split(train, y, [])
  end
  def split([], _, _) do :error end
  def split([head|rest], y, acc)do
    if head == y do
      {acc, rest}
    else
      acc = acc ++ [head]
      split(rest, y, acc)
    end
  end

  #Johan Montelius's Solution to making the main/2 function
  def main([], n) do
    {n ,[], []}
  end
  def main([h|t], n) do
    case main(t,n) do
      {0, drop, taken} -> {0, [h|drop], taken}
      {n, drop, taken} -> {n-1, drop, [h|taken]}
    end
  end

  # def main([], acc, :rev) do acc end
  # def main([head|tail],acc, :rev) do
  #   acc = head ++ acc
  #   rev(tail, acc)
  # end

  def test() do
    train = [:a,:b,:c]
    train2 = [:d,:e]
    n = 2
    # take(train,n)
    # drop(train, 1)
    # append(train, train2)
    # member(train, :Z)
    # position(train, :c)
    # split(train, :b)
  end
end
