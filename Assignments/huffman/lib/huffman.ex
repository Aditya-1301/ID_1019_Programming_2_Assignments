defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    file = "lib\\sample.txt"
    f = getSample(file); #IO.inspect(f)
    t = tree(f); #IO.inspect(t)
    et = encode_table(t); #IO.inspect(et)
    dt = decode(et)
    e_text = encode_text(sample(), et, [])
    d_text = decode(e_text, dt) #; #IO.inspect(dt)
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

  def tree(text)do
    f = freq(text)
    freq_list_sorted = Enum.into(f, []) |> Enum.sort(fn({_, f1}, {_, f2}) -> f1 <= f2 end)
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

  ##################################################// ENCODE TABLE

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

  def encode_text([], _, acc) do acc end
  def encode_text([head|rest], table, acc) do
    if(Map.get(table, head)!=nil) do
      acc = acc ++ Map.get(table, head)
      encode_text(rest, table, acc)
    else
      encode_text(rest, table, acc)
    end
  end

  #################################################################

  ##################################################// DECODE TABLE

  #################################################################

  def decode(table) do
    Map.new(table, fn {key, value} -> {value, key} end)
  end

  def decode(bits, table) do
    decode(bits, table, '', '')
  end

  def decode([], _, _, result) do result end
  def decode([head|rest], table, key, result) do
    key = key ++ [head]
    temp = Map.get(table, key)
    if temp != nil do
      decode(rest, table, '' , result ++ [temp])
    else
      decode(rest, table, key, result)
    end
  end

  #################################################################

  ##################################################// BENCHMARKING

  #################################################################

  def bench(n) do
    file = "lib\\sample1.txt"
    {text, b} = read(file, n)
    #IO.inspect(text)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    #IO.inspect(tree)
    {encode, t3} = time(fn -> encode_table(tree) end)
    #IO.inspect(encode)
    s = map_size(encode)
    {dec, _} = time(fn -> decode(encode) end)
    #IO.inspect(dec)
    {encoded, t5} = time(fn -> encode_text(text, encode, []) end)
    IO.inspect(encoded)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, dec) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

 # Get a suitable chunk of text to encode.
  def read(file, n) do
   {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end

end

###################################################################


## Huffman tree -> Hello : %{5, ["L", %{3, ["O", %{2, ["H", "E"]}]}]}

# def encode(text, table) do
# 	Enum.map(text, fn(x)-> Map.get(table, x) end)
# 	|> List.flatten()
# end
