defmodule EnvTree do

  def new do nil end

  def add(nil, key, value) do
  #... adding a key-value pair to an empty tree ..
    {:node, key, value, nil, nil}
  end
  def add({:node, key, _, left, right}, key, value) do
  #... if the key is found we replace it ..
    {:node, key, value, left, right}
  end
  def add({:node, k, v, left, right}, key, value) when key < k do
  #... return a tree that looks like the one we have
  #but where the left branch has been updated ...
    {:node, k, v, add(left, key, value), right}
  end
  def add({:node, k, v, left, right}, key, value) do
  #... same thing but instead update the right banch
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(nil, key) do
    nil
  end
  def lookup({:node, key, value, left, right}, key) do
    {key, value}
  end
  def lookup({:node, k, v, left, right}, key) when key < k do
    lookup(left, key)
  end
  def lookup({:node, k, v, left, right}, key) do
    lookup(right, key)
  end



  def remove(nil, _) do
    nil
  end
  def remove({:node, key, _, nil, right}, key) do
    right
  end
  def remove({:node, key, _, left, nil}, key) do
    left
  end
  def remove({:node, key, _, nil, nil}, key) do
    nil
  end
  def remove({:node, key, _, left, right}, key) do
    {:node, k1, value } = leftmost(right)
    {:node, k1, value, left, remove(right, k1)}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end

  def leftmost({:node, key, value, nil, _}) do
		{:node, key, value}
	end
	def leftmost({:node, _, _, left, _}) do
		leftmost(left)
	end
end
