defmodule Env do

  @type value :: any()
  @type key :: atom()
  @type env :: %{key => value}

  def new do %{} end
  def new(map) do map end

  def add(key, value) do
    env = Map.put(%{}, key, value)
  end
  def add(key, value, env) do
    env = Map.put(env, key, value)
  end

  def remove([key],env) do
    env = Map.delete(env, key)
  end
  def remove([key|rest], env) do
    env = remove([key], env)
    env = remove(rest, env)
  end

  def lookup(key, env) do
    Map.get(env, key, nil)
  end

  def closure(keyss, env) do
    Enum.reduce(keyss, %{}, fn(key, acc) ->
      case acc do
        :error ->
          :error

        cls ->
          case Map.get(env, key) do
            {:ok, value} ->
              Map.put(cls, key, value)

            :error ->
              :error
          end
      end
    end)
  end

  def args(pars, args, env) do
    par_args = List.zip([pars, args])
    Map.merge(Map.new(par_args), env)
  end

  def test do
    env = new()
    env = add(:X, 10, env)
    IO.inspect(env)
    env = add(:Y, 20, env)
    IO.inspect(env)
    env = add(:Z, 30, env)
    IO.inspect(env)
    list = [:X, :Y]
    env = remove(list, env)
    env
    #IO.inspect(lookup(:X, env))


    # map = %{:lukas => 10, :samuel => 34}
    # env = new(map)
    # IO.inspect(lookup(:yohana, env))
    # env
  end

end
