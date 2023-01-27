defmodule Queue do
  # def add([], elem) do [elem] end
  # def add([h|t], elem) do [h | add(t, elem)] end

  # def remove([]) do :error end
  # def remove([elm|rest]) do {:ok, elm, rest} end
  def reverse(x) do {:error, reverse(x)}
end
