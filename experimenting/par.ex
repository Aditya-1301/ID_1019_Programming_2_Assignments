defmodule Par do
  def can_partition(nums) do
    nums = Enum.sort(nums)
    partition(nums, [])
  end

  def partition([], _) do false end
  def partition([h|t], acc) do
    acc = acc ++ [h]
    if(Enum.sum(acc) == Enum.sum(t))do
        true
    else
        partition(t, acc)
    end
  end
end
