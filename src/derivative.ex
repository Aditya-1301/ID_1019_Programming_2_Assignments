defmodule Derivative do

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} |
  {:div, expr(), expr()} | {:exp, expr(), literal()} | {:sin, expr()}|
  {:ln, expr()} | {:cos, expr()} | literal()

  def test do
    arg = {:add, {:mul, {:var, :v} , {:num, 5}}, {:num, 3}}
    arg2 = {:exp, :v, {:num, 5}}
    arg3 = {:sin, :v}
    arg4 = {:ln, :v}
    arg5 = {:div, {:num, 15}, :v}
    arg6 = {:mul, {:sqrt, {:var, :v}}, {:num, 5}}
    #{:mul, {:exp, :v, {:div, {:num, 1}, {:num, 4}}}, {:num, 5}}
    d1 = deriv(arg, :v)
    #d2 = deriv(arg2, :v)
    #d3 = deriv(arg3, :v)
    #d4 = deriv(arg4, :v)
    #d5 = deriv(arg5, :v)
    #d6 = deriv(arg6, :v)
    # :io.format("~w\n~w\n~w\n", [d1,d2,d3])
    # :io.format("~w\n~w\n~w\n", [d4,d5,d6])

    s1 = simplify(d1)

    IO.write("expression: #{pprint(arg)}\n")
    IO.write("derivative: #{pprint(d1)}\n")
    IO.write("simplified: #{pprint(s1)}\n")
    :io.format("~w", [s1])
  end

  def deriv({:var, v}, v), do: {:num , 1}
  def deriv(v, {:var, v}), do: {:num , 1}
  def deriv({:num, _}, _), do: {:num , 0}
  def deriv(_, {:num, _}), do: {:num , 0}
  def deriv({:var, _}, _), do: {:num, 0}
  def deriv(_, {:var, _}), do: {:num, 0}

  #1 Taking derivative for the sum of two functions
    def deriv({:add, e1, e2}, v), do: {:add, deriv(e1, v), deriv(e2, v)}

  #2 Taking derivative for the product of two functions
    def deriv({:mul, e1, e2}, v), do: {:add, {:mul, deriv(e1, v), e2}, {:mul, deriv(e2, v), e1}}

  #3 Power Rule in derivatives
    #def deriv({:exp, v, {:num, n}}, v), do: {:mul, {:num, n}, {:exp, v, {:num, n-1}}}
    def deriv({:exp, e1, {:num, n}}, v), do: {:mul, {:num, n}, {:mul, {:exp, e1, {:num, n-1}}, deriv(e1, v)}}
    def deriv({:exp, _, {:num, n}}, _), do: {:num, 0}

  #4 Taking derivative for the Sin function
    def deriv({:sin, v}, v), do: {:cos, v}
    def deriv({:sin, _}, _), do: {:num, 0}
    # This can be used in a more general case ¬ def deriv({:sin, e1}, v) do: {:mul {:cos, e1}, deriv(e1,v)}

  #5 Taking derivative for the Logarithm function
    def deriv({:ln, v}, v) when v > 0, do: {:div, {:num, 1}, v}
    def deriv({:ln, _}, _), do: {:num, 0}

  #6 Taking derivative for v^(-1)
    def deriv({:div, {:num, n}, v}, v) when v != 0, do: {:div, {:num, -n}, {:mul, v, v}}
    def deriv({:div, {:num, n}, _}, _), do: {:num, 0}

  #7 Taking derivative of the Square root function
    def deriv({:sqrt, e1}, v) when v > 0, do: {:mul, {:div, {:num, 1}, {:mul, {:num, 2}, {:sqrt, e1}}},deriv(e1,v)}
    def deriv({:sqrt, _}, _), do: {:num, 0}
    # def deriv({:exp, v, {:div, {:num, 1}, {:num, n}}}, v) when v > 0, do:
    #   {:div, {:num, 1}, {:mul, {:num, n}, {:exp, v, {:div, {:num, 1 - n},{:num, n}}}}}

  #Simplify Funtions:-

  def simplify_add({:num, 0}, e2) do simplify(e2) end
  def simplify_add(e1, {:num, 0}) do simplify(e1) end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:var, v}, {:var, v}) do {:exp, {:var, v}, {:num, 2}} end
  def simplify_mul({:var, v}, {:exp, {:var, v}, {:num, n}}) do {:exp, {:var, v}, {:num, n+1}} end
  def simplify_mul({:exp, {:var, v}, {:num, n}}, {:var, v}) do {:exp, {:var, v}, {:num, n+1}} end

  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e2}) do {:mul, {:num, n1*n2}, e2} end
  def simplify_mul({:num, n1}, {:mul, e2, {:num, n2}}) do {:mul, {:num, n1*n2}, e2} end
  def simplify_mul({:mul, {:num, 0}, e1}, {:num, n2}) do {:num, 0} end
  def simplify_mul({:mul, e1, {:num, 0}}, {:num, n2}) do {:num, 0} end
  def simplify_mul({:mul, {:num, n1}, e1}, {:num, n2}) do {:mul, {:num, n1*n2}, e1} end
  def simplify_mul({:mul, e1, {:num, n1}}, {:num, n2}) do {:mul, {:num, n1*n2}, e1} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp({:num, 0},_) do {:num, 0} end
  def simplify_exp(_,{:num, 0}) do {:num, 1} end
  def simplify_exp({:num, n1}, {:num, n2}) do {:exp, n1, n2} end
  def simplify_exp({:num, n1},e2) do {:exp, {:num, n1}, e2} end
  def simplify_exp(e1,{:num, n2}) do {:exp, e1, {:num, n2}} end

  def simplify({e}) do simplify(e) end
  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end
  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end

  def simplify({:exp, e1, e2}), do: {:exp, simplify(e1), simplify(e2)}
  def simplify({:div, e1, e2}), do: {:div, simplify(e1), simplify(e2)}
  def simplify({:sqrt, e1}), do: {:sqrt, simplify(e1)}
  def simplify({:sin, e1}), do: {:sin, simplify(e1)}
  def simplify({:cos, e1}), do: {:cos, simplify(e1)}

  def callSimplify(e) do
    result = simplify(e)
    if e != result do
      simplify(result)
    else
      result
    end
  end

  def pprint({e}), do: "#{pprint(e)}"
  def pprint({:num, 0}) do end
  def pprint({:num, n}), do: "#{n}"
  def pprint({:var, v}), do: "#{v}"
  def pprint({:mul, {:num, 0}, {:var ,v}}) do end
  def pprint({:mul, {:num, n}, {:var ,v}}) do "#{pprint(n)}#{pprint(v)}" end
  def pprint({:add, e1, {:num, 0}}), do: "#{pprint(e1)}"
  def pprint({:add, {:num, 0}, e2}), do: "#{pprint(e2)}"
  def pprint({:add, e1, e2}), do: "#{pprint(e1)} + #{pprint(e2)}"
  def pprint({:mul, e1, e2}), do: "(#{pprint(e1)} * #{pprint(e2)})"
  def pprint({:exp, e1, e2}), do: "#{pprint(e1)}^#{pprint(e2)}"

end
