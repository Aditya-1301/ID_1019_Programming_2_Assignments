defmodule Exp do

  @type literal() :: {:num, number()} | {:var, atom()} | {:q, number(), number()}

  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | literal()

  def eval({:num, n}, environment) do {:num, n} end
  def eval({:var, v}, environment) do {:num, environment[v]} end
  def eval({:q, n, m}, environment) do
    gcd = Integer.gcd(n, m)
	 	n = div(n, gcd)
	 	m = div(m, gcd)
	 	{:q, n, m}
  end
  def eval({:add, a1, a2}, environment) do
    add(a1, a2, environment)
  end
  def eval({:sub, a1, a2}, environment) do
    sub(a1, a2, environment)
  end
  def eval({:div, a1, a2}, environment) when a2 != 0 do
    div(a1, a2, environment)
  end
  def eval({:mul, a1, a2}, environment)  do
    mul(a1, a2, environment)
  end

  def eval1(expression, environment) do
		result = eval(expression, environment)
		if result == expression do
			result
		else
			eval1(result, environment)
		end
	end

  def add({:num, n}, {:num, m}, _) do {:num, n + m} end
  def add({:q, n, m}, {:num, a}, _) do {:q, a*m + n, m} end
  def add({:num, a}, {:q, n, m}, _) do {:q, a*m + n, m} end
  def add(a, b, env) do {:add, eval(a, env), eval(b, env)} end

  def sub({:num, n}, {:num, m}, _) do {:num, n - m} end
  def sub({:q, n, m}, {:num, a}, _) do {:q, a*m - n, m} end
  def sub({:num, a}, {:q, n, m}, _) do {:q, a*m - n, m} end
  def sub(a, b, env) do {:sub, eval(a, env), eval(b, env)} end

  def div({:num, n}, {:num, 1}, _) do {:num, n} end
  def div({:num, n}, {:num, m}, _) do {:q, n , m} end
  def div({:q, n, m}, {:num, a}, _) do {:q, n, a*m} end
  def div({:num, a}, {:q, n, m}, _) do {:q, a*m, n} end
  def div(a, b, env) do {:div, eval(a, env), eval(b, env)} end

  def mul({:num, n}, {:num, m}, _) do {:num, n*m} end
  def mul({:q, n, m}, {:num, a}, _) do {:q, a*n , m} end
  def mul({:num, a}, {:q, n, m}, _) do {:q, a*n, m} end
  def mul(a, b, env) do {:mul, eval(a, env), eval(b, env)} end#

  def test() do
		exp = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}
		eval1(exp, Map.put(%{}, :x, 10)) |> :io.write
	end

  def test2() do
		exp = {:div, {:sub, {:mul, {:num, 7}, {:var, :x}}, {:num, 3}}, {:num, 2}}
		eval1(exp, Map.put(%{}, :x, 10)) |> :io.write
	end

	def test3() do
		exp = {:mul, {:num, 2}, {:q, 3, 4}}
		eval1(exp, Map.put(%{}, :x, 10)) |> :io.write
	end

end
