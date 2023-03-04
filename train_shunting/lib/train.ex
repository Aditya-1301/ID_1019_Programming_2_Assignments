defmodule Train do

  def append([], []) do [] end
  def append([], [head|rest]) do [head|rest] end
  def append([], train) do [train] end
  def append([head|tail], train) do
    [head|append(tail, train)]
  end

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
    acc = append(acc,[head])
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
    position(train, y, 1)
  end
  def position([], _, acc) do acc end
  def position([head|rest], y, acc) do
    if(head == y) do
      acc
    else
      position(rest, y, acc + 1)
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
      acc = append(acc,[head])
      split(rest, y, acc)
    end
  end


  def main([h|t], n) do
    l = length([h|t])
    if(l < n) do
      IO.inspect({0, [], [h|t]})
    else
      IO.inspect(l)
      IO.inspect(n)
      map = Enum.map([h|t], fn(x) ->
        {position([h|t], x), x}
      end) |> Map.new()
      # IO.inspect(Map.get(map,l))
      # IO.inspect(Map.get(map,n))
      # IO.inspect(Map.get(map,l-n))
      {p1,p2} = split([h|t], Map.get(map, l-n + 1))
      IO.inspect({p1,p2})
      {l-n-1, p1, append([Map.get(map, n + 1)], p2)}
    end
  end

  def element_at_pos([h], pos) do h end
  def element_at_pos([h|t], pos) do
    if(position([h|t], h) == pos) do
      h
    else
      element_at_pos(t, pos)
    end
  end

  def eMap([h|t], map) do map end
  def eMap([h|t], map) do
    map = Map.put(map, position([h|t], h, 1), h)
    IO.inspect(map)
    eMap(t, map)
  end
  # def main([], acc, :len) do acc end
  # def main([h|t], acc, :len) do
  #   acc = acc + 1
  #   main(t, acc, :len)
  # end
  # def main()
  # def main([head|rest], y, acc, :split) do
  #   if head == y do
  #     {acc, rest}
  #   else
  #     acc = append(acc,[head])
  #     split(rest, y, acc)
  #   end
  # end
  # def main([], _, acc, :pos) do acc end
  # def main([head|rest], y, acc, :pos) do
  #   if(head == y) do
  #     acc
  #   else
  #     position(rest, y, acc + 1)
  #   end
  # end

  #Johan Montelius's Solution to making the main/2 function
  # def main([], n) do
  #   {n ,[], []}
  # end
  # def main([h|t], n) do
  #   case main(t,n) do
  #     {0, drop, taken} -> {0, [h|drop], taken}
  #     {n, drop, taken} -> {n-1, drop, [h|taken]}
  #   end
  # end

  def test() do
    train = [:a,:b,:c,:D]
    train2 = [:d,:e]
    n = 3
    # take(train,n)
    # drop(train, 1)
    # append(train, train2)
    # member(train, :Z)
    # position(train, :c)
    # split(train, :b)
    #main(train, n)
    main(train ,5)
    #IO.inspect(Shunt.find([:a,:b],[:b,:a]))
    #IO.inspect(Shunt.few([:a,:b],[:b,:a]))
    #IO.inspect(Moves.sequence(Shunt.find([:a,:b,:c],[:b, :a, :c]),[:a ,:b, :c]))
  end
end
