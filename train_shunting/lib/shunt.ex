defmodule Shunt do

  def find([], []) do [] end
  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    {hl, tl} = {length(hs), length(ts)}
    [{:one, tl + 1}, {:two, hl}, {:one, -(tl + 1)}, {:two, -hl}] ++ find(Train.append(ts, hs), ys)
  end

  def few([], []) do [] end
  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    {hl, tl} = {length(hs), length(ts)}
    case Train.position(xs, y) do
      1 ->
      few(Train.append(hs, ts), ys)
      _ ->
      [{:one, tl + 1}, {:two, hl}, {:one, -(tl + 1)}, {:two, -hl}] ++
      few(Train.append(ts, hs), ys)
    end
  end

  def rules([]) do [] end
  def rules([head | tail]) do
    case head do
      {_, 0} ->
        rules(tail)
      head ->
        case tail do
          [] ->
            [head]
          [h | t] ->
            case {head, h} do
              {{track, n}, {track, m}} ->
                [{track, n + m}] ++ rules(t)
              _ ->
              [head] ++ rules([h] ++ t)
            end
        end
    end
  end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end
end
