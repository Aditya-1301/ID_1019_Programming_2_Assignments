defmodule Huffman do
  def test do
    file = "lib\\sample.txt"
    getSample(file)
  end

  def getSample(file) do
    input = File.read!(file)
    freq(input)
  end
  def freq(string) do
    loop(String.graphemes(string), %{})
  end

  def loop([], map) do map end
  def loop([head|rest], map) do
    if Map.has_key?(map, head) do
      loop(rest,map)
    else
      count = [head|rest] |> Enum.count(fn(x) -> x == head end)
      IO.puts("#{head} => #{count}")
      map = Map.put(map, head, count)
      loop(rest, map)
    end
  end
end


## Huffman tree -> Hello : %{5, ["L", %{3, ["O", %{2, ["H", "E"]}]}]}
