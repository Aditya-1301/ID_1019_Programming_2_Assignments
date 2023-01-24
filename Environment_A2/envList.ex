defmodule EnvList do

    def test do

      a1 = []
      a2 = add(a1, :a, 1)
      a3 = add(a2, :b, 2)
      a4 = add(a3, :c, 3)
      a5 = add(a4, :d, 4)

      :io.format("~w\n~w\n",[a1, a2])
      :io.format("~w\n~w\n~w\n",[a3 ,a4, a5])
      #:io.format("~w\n", lookup(a5, :b))

      a5 = remove(a5, :b)
      :io.format("~w\n",[a5])

    end

    def new do [] end

    def add([], key, value) do [{key,value}] end
    def add([kv | {key, _}], key, value) do [kv | {key, value}] end
    def add([kv | map], key, value) do [kv | add(map, key, value)] end

    def lookup([], key) do nil end
    def lookup([ {key, value} | _], key) do {key, value} end
    def lookup([{_,_} | rest], key) do lookup(rest,key) end

    def remove([], key) do nil end
    def remove([{key, _} | rest], key) do rest end
    def remove([map | {key, _}], key) do map end
    def remove([kv | map], key) do [kv | remove(map, key)] end
    # def remove([kv | map], key) do [remove(kv, key)|map] end

end
