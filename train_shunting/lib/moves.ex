defmodule Moves do
  def sequence([], state) do [state] end
  def sequence([move|rest], state) do
    [state | sequence(rest, single(move, state))]
  end

  def single({_, 0}, state) do state end
  def single(move, {main, one, two}) do
    case move do
      {:one, n} ->
        cond do
          n < 0 ->
            mvd_wgs = Train.take(one, -n)
            {Train.append(main, mvd_wgs), Train.drop(one, -n), two}
          true ->
            {0, drop, take} = Train.main(main, n)
            {drop, Train.append(one, take), two}
        end
      {:two, n} ->
        cond do
          n < 0 ->
            mvd_wgs = Train.take(two, -n)
            {Train.append(main, mvd_wgs), one, Train.drop(two, -n)}
          true ->
            {0, drop, take} = Train.main(main, n)
            {drop, one, Train.append(two, take)}
        end
    end
  end
end
