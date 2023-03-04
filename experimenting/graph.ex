defmodule Graph do
  def flood do
    graph =
      %{
        S1: %{:A, :B, :C:},
        S2: %{:D, :E, :F, :G},
        S3: %{:H, :I}
        S4: %{:S1, :S2, :S3}
      }
  end
end
