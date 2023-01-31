defmodule Env do

  @type value :: any()
  @type key :: atom()
  @type env :: %{key => value}

  def new do %{} end
  def new(map) do map end

  def add(key, value, env) do
    env = Map.put(env, key, value)
  end
  def remove(key, env) do
    env = Map.delete(env, key)
  end
  def lookup(key, env) do
    i = Enum.into(Map.get(env, key, "#{key} is not present in the Environment"), [{}])
    List.delete(i, {})
  end

  def test do
    env = new()
    env = add(:X, 10, env)
    IO.inspect(env)
    env = add(:Y, 20, env)
    IO.inspect(env)
    env = add(:Z, 30, env)
    IO.inspect(env)
    env = remove(:Y, env)
    IO.inspect(lookup(:X, env))
    # map = %{:lukas => 10, :samuel => 34}
    # env = new(map)
    # IO.inspect(lookup(:yohana, env))
    # env
  end

  # @type value :: any()
  # @type key :: atom()
  # @type env :: [{key, value}]

  # def new do [] end
  # def new(list) do list end

  # def add(key, value, env) do
  #   env = [{key,value} | env]
  # end
  # def remove(key, env) do
  #   env = List.delete(env, {key, _},env)
  # end
  # def lookup(_,[]) do nil end
  # def lookup(key, [{key,value}|rest]) do
  #   case env do
  #     {key}
  #   end
  # end

end
