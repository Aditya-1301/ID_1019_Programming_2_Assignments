defmodule EnvTree do
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
    add(left, key, value)
  end
  def add({:node, k, v, left, right}, key, value) do
  #... same thing but instead update the right banch
    add(right, key, value)
  end



  def remove(nil, _) do
    ...
  end
  def remove({:node, key, _, nil, right}, key) do
    ...
  end
  def remove({:node, key, _, left, nil}, key) do
    ...
  end
  def remove({:node, key, _, left, right}, key) do
    ... = leftmost(right) {:node, ..., ..., ..., ...}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, ..., right}
  end
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, ...}
  end
  def leftmost({:node, key, value, nil, rest}) do
    ...
  end
  def leftmost({:node, k, v, left, right}) do
    ... = leftmost(left) ...
  end
end
