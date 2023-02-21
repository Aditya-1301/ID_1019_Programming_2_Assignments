defmodule Graph do
  def create(filename) do
    input = File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.filter(&(&1 != ""))
      |> Stream.map(&String.split(&1, " "))
      |> Stream.map(&{String.to_atom(Enum.at(&1, 1)), &1})
      |> Enum.into(%{})
    valves = for {valve, data} <- input do
      edges = Enum.map(Enum.drop(data, 5), &String.replace(&1, ",", ""))
      flow_rate = String.to_integer(Enum.at(String.split(Enum.at(data, 4), "="), 1))
      {valve, %{flow_rate: flow_rate, edges: edges}}
    end
    Map.new(valves)
  end

  
end
