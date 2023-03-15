defmodule Morse do

  def test do
    map = codes()
    e = encode('aditya', map, [])
    IO.inspect(e)
    es = encoded_string(e, "")
    IO.inspect(es)
    ec = to_char_list(es)
    IO.inspect(ec)
    c1 = String.split(".- -.. .. - -.-- .- ")
    c2 = String.split(".- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...")
    c3 = String.split(".... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----")
    IO.inspect(decode(c1))
    IO.inspect(decode(c2))
    IO.inspect(decode(c3))
  end

  def encode([], _, code) do code end
  def encode([text|rest], map, code) do
    case Map.get(map, text) do
      nil -> ""
      char -> code = code ++ char
    end
    code = code ++ [Map.get(map, text)]
    encode(rest, map, code)
  end

  def encoded_string([], acc) do acc end
  def encoded_string([text|rest], acc)do
    acc = acc <> text <> " "
    encoded_string(rest, acc)
  end

  def decode_table(table) do
    Map.new(table, fn {key, value} -> {value, key} end)
  end
  def decode(code) do
    tree = morse()
    decode(code, tree)
  end
  def decode([], _) do [] end
  def decode([head | tail], tree) do
    [decode_char(head, tree) | decode(tail, tree)]
  end

  def decode_char(_signal, :nil) do :no end
  def decode_char(sequence, {:node, character, tree_left, tree_right}) do
    case String.at(sequence, 0) do
      "-" ->
        decode_char(String.slice(sequence, 1..-1), tree_left)
      "." ->
        decode_char(String.slice(sequence, 1..-1), tree_right)
      _ ->
        character
    end
  end

  def morse do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def codes do
    %{
      32 => "..--",
      37 => ".--.--",
      44 => "--..--",
      45 => "-....-",
      46 => ".-.-.-",
      47 => ".-----",
      48 => "-----",
      49 => ".----",
      50 => "..---",
      51 => "...--",
      52 => "....-",
      53 => ".....",
      54 => "-....",
      55 => "--...",
      56 => "---..",
      57 => "----.",
      58 => "---...",
      61 => ".----.",
      63 => "..--..",
      64 => ".--.-.",
      97 => ".-",
      98 => "-...",
      99 => "-.-.",
      100 => "-..",
      101 => ".",
      102 => "..-.",
      103 => "--.",
      104 => "....",
      105 => "..",
      106 => ".---",
      107 => "-.-",
      108 => ".-..",
      109 => "--",
      110 => "-.",
      111 => "---",
      112 => ".--.",
      113 => "--.-",
      114 => ".-.",
      115 => "...",
      116 => "-",
      117 => "..-",
      118 => "...-",
      119 => ".--",
      120 => "-..-",
      121 => "-.--",
      122 => "--.."
    }
  end
end
