defmodule Huffman do

  def test do
    file = "lib\\sample.txt"
    f = getSample(file); #IO.inspect(f)
    t = tree(f); #IO.inspect(t)
    et = encode_table(t); #IO.inspect(et)
    dt = decode(et)
    e_text = encode_text('Trello', et, [])
    dt = decode(e_text, dt) |> to_string() ; #IO.inspect(dt)
  end


  #################################################################

  #####################################################// FREQUENCY

  #################################################################

  def getSample(file) do
    input = File.read!(file) # "Hello" #
    freq(input)
  end
  def freq(string) do
    chars = to_charlist(string)
    loop(chars, %{})
  end

  def loop([], map) do map end
  def loop([head|rest], map) do
    if Map.has_key?(map, head) do
      loop(rest,map)
    else
      count = [head|rest] |> Enum.count(fn(x) -> x == head end)
      #IO.puts("#{head} => #{count}")
      map = Map.put(map, head, count)
      loop(rest, map)
    end
  end

  #################################################################

  ##################################################// HUFFMAN TREE

  #################################################################

  def tree(freq)do
    freq_list_sorted = Enum.into(freq, []) |> Enum.sort(fn({_, f1}, {_, f2}) -> f1 <= f2 end)
    # IO.inspect(freq_list_sorted)
    huffman_tree(freq_list_sorted)
  end

  def huffman_tree([{tree, _}]) do tree end
  def huffman_tree([{h1,hf1}, {h2, hf2}|rest]) do
    # IO.inspect({{h1, h2}, hf1 + hf2})
    # IO.inspect(insert({{h1, h2}, hf1 + hf2}, rest))
    huffman_tree(insert({{h1, h2}, hf1 + hf2}, rest))
  end

  def insert({a, f}, []) do
    [{a, f}]
  end
  def insert({a, f1}, [{b, f2}|rest]) do
    if f1 < f2 do
      [{a, f1}, {b, f2}|rest]
    else
      [{b, f2} | insert({a, f1}, rest)]
    end
  end

  #################################################################

  ###########################################// encode_table\DECODE TABLE

  #################################################################

  def encode_table(tree) do
    encode_table(tree, %{}, [])
  end
  def encode_table({left, right}, table, code) do
    table = encode_table(left, table, [0|code])
    encode_table(right, table, [1|code])
  end
  def encode_table(char, table, code) do
    Map.put(table, char, Enum.reverse(code))
  end

  def encode(text, table) do
		Enum.map(text, fn(x)-> Map.get(table, x) end)
		|> List.flatten()
	end

  def encode_text([], _, acc) do acc end
  def encode_text([head|rest], table, acc) do
    if(Map.get(table, head)!=nil) do
      acc = acc ++ Map.get(table, head)
      encode_text(rest, table, acc)
    else
      encode_text(rest, table, acc)
    end
  end

  # def decode_table(map) do
	# 	Map.to_list(map)
	# 	|> Enum.reduce(Map.new(), fn({key, value}, acc)-> Map.put(acc, value, key) end)
	# end

  # def decode(list, table) do
	# 	decode(list, table, '', '')
	# 	|> Enum.reverse()
	# end

	# def decode([], table, result, key) do result end
	# def decode([head|rest], table, result, key) do
	# 	key = key ++ [head]
	# 	temp = Map.get(table, key)
	# 	if temp != nil do
	# 		decode(rest, table, [temp]++result, '')
	# 	else
	# 		decode(rest, table, result, key)
	# 	end
	# end

  def decode(table) do
    Map.new(table, fn {key, value} -> {value, key} end)
  end

  def decode(bits, table) do
    decode(bits, table, '', '') |> Enum.reverse()
  end

  def decode([], _, _, result) do result end
  def decode([head|rest], table, key, result) do
    key = key ++ [head]
    temp = Map.get(table, key)
    if temp != nil do
      decode(rest, table, '' , [temp] ++ result)
    else
      decode(rest, table, key, result)
    end
  end

  #################################################################
end


## Huffman tree -> Hello : %{5, ["L", %{3, ["O", %{2, ["H", "E"]}]}]}
