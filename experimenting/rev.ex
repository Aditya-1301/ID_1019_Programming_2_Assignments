defmodule Rev do
  def test do
    s = "[1,2,3,4]" #|> String.reverse
    String.at(s,3)
    #rev(s)
    #reverseTailRecursive(s,[])
  end

  def reverse([]) do [] end
  def reverse([head|tail]) do
    reverse(tail) ++ [head]
  end

  def reverseTailRecursive([],acc) do acc end
  def reverseTailRecursive([head|tail], acc) do
    reverseTailRecursive(tail, [head] ++ acc)
  end

  def readFile do
    file = "D:\\TCOMK Pdfs\\Year 2\\Period 3\\Programming 2\\ID_1019_Programming_2_Assignments\\experimenting\\input3.txt"
    {:ok, input} = File.read(file)
    lines = String.split(input, "\r\n")
    loop1(lines,0)
  end

  def loop1([], priority) do priority end
  def loop1([head|tail], priority) do
      listParts = Tuple.to_list(String.split_at(head,trunc(String.length(head)/2)))
      loop1(tail, priority + extractPriority(listParts))
  end

  def extractPriority(listParts) do
      part1 = MapSet.new(); part2 = MapSet.new()
      part1 = MapSet.new(String.graphemes(getListHead(listParts)))
      part2 = MapSet.new(String.graphemes(getListTail(listParts)))
      [map] = MapSet.to_list(MapSet.intersection(part1,part2))
      IO.inspect(map)
      map = map |> Enum.map(&String.to_charlist/1) |> List.flatten
      [value] = map
      cond do
        65 <= value and value <= 90 -> value - 38
        97 <= value and value <= 122 -> value - 96
      end
  end

  def getListHead([head|tail]) do head end

  def getListTail([last]) do last end
  def getListTail([head|tail])do
      getListTail(tail)
  end
end
