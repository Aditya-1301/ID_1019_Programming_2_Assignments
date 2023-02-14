defmodule Dub do
  def double( [] ) do [] end
  def double( [head | tail] ) do
    [head * 2 | double(tail)]
  end

  def double( [] , f) do [] end
  def double( [head | tail] ,f) do
    [f.(head) | double(tail)]
  end

  def five([]) do [] end
  def five([head|tail]) do
    [(head + 5) | five(tail)]
  end
  def five([], f) do [] end
  def five([head|tail], f) do
    [f.(head) | five(tail)]
  end

  def animal([]) do [] end
  def animal([:dog]) do [:fido] end
  def animal([h|t]) when h == :dog do
    [:fido | t]
  end

  def double_five_animal([], _) do [] end
  def double_five_animal(list, arg) do
      case arg do
        :double ->
          g = fn(x) -> x * 2 end
          f = fn([h|t],g) -> [h*2 | g(t,g)] end
        :five ->
          g = fn([x],g) -> [x + 5] end
          f = fn([h|t],g) -> [ h + 5 | g(t,g)] end
        :animal ->
          g = fn(:dog) :fido end
          f = fn([:dog|t],g) -> [ :fido + 5 | g(t,g)] end
      end
  end

  def sum([],acc) do acc end
  def sum([head|tail],acc) do
    sum(tail,head+acc)
  end

  def sumF([], acc, _) do acc end
  def sumF([head|tail], acc, f) do
    sumF(tail, f.(head,acc),f)
  end
end
