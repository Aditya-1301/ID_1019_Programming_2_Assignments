defmodule Eag do
  def eval(seq) do
    eval_seq(seq, Env.new())
  end

  def eval_expr({:atm, id}, _) do
    {:ok, id}
  end

  def eval_expr({:var, v}, env) do
    case Env.lookup(v, env) do
      nil ->
        IO.puts("variable binding for #{v} is not present")
        :error

      {_, str} ->
        {:ok, str}
    end
  end

  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error ->
        :error

      {:ok, hs} ->
        case eval_expr(tail, env) do
          :error -> :error
          {:ok, ts} -> {:ok, {hs, ts}}
        end
    end
  end

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, str} -> eval_cls(cls, str, env)
    end
  end

  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error -> :error
      closure -> {:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error

      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error

          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end

      {:ok, _} ->
        :error
    end
  end

  def eval_match(:ignore, _, env) do
    {:ok, env}
  end

  def eval_match({:atm, a}, a, env) do
    {:ok, env}
  end

  def eval_match({:var, v}, str, env) do
    case Env.lookup(v, env) do
      nil -> {:ok, Env.add(v, str, env)}
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end

  def eval_match({:cons, head, tail}, {hs, ts}, env) do
    case eval_match(head, hs, env) do
      :fail -> :fail
      {:ok, env} -> eval_match(tail, ts, env)
    end
  end

  def eval_match(_, _, _) do
    :fail
  end

  def eval_scope(ptr, env) do
    Env.remove(extract_vars(ptr), env)
  end

  def eval_seq([ptr], env) do
    eval_expr(ptr, env)
  end

  def eval_seq([{:match, a, b} | rest], env) do
    case eval_expr(b, env) do
      :error ->
        :error

      {:ok, str} ->
        # IO.write("b: #{inspect(str)}\n")
        env = eval_scope(a, env)

        case eval_match(a, b, env) do
          :fail -> :error
          {:ok, env} -> eval_seq(rest, env)
        end
    end
  end

  def eval_cls([], _, _) do
    :error
  end

  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    case eval_match(ptr, str, eval_scope(ptr, env)) do
      :fail ->
        eval_cls(ptr, str, env)

      {:ok, env} ->
        eval_seq(seq, env)
    end
  end

  def eval_expr({:fun, id}, _env) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, []}}
  end

  def extract_vars(expr) do
    extract_vars(expr, [])
  end

  def extract_vars({:atm, _}, vars) do
    vars
  end

  def extract_vars(:ignore, vars) do
    vars
  end

  def extract_vars({:var, var}, vars) do
    [var | vars]
  end

  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end

  def eval_args(args, env) do
    eval_args(args, env, [])
  end

  def eval_args([], _, strs) do
    {:ok, Enum.reverse(strs)}
  end

  def eval_args([expr | exprs], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error

      {:ok, str} ->
        eval_args(exprs, env, [str | strs])
    end
  end

  def test do
    seq = [
      {:match, {:var, :x}, {:atm, :a}},
      {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
      {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
      {:var, :z}
    ]

    Eag.eval(seq)
  end

  def test2 do
    seq = [
      {:match, {:var, :x}, {:atm, :a}},
      {:case, {:var, :x},
       [{:clause, {:atm, :b}, [{:atm, :ops}]}, {:clause, {:atm, :a}, [{:atm, :yes}]}]}
    ]

    Eag.eval_seq(seq, Env.new())
  end

  def test3 do
    seq = [
      {:match, {:var, :x}, {:atm, :a}},
      {:match, {:var, :f}, {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
      {:apply, {:var, :f}, [{:atm, :b}]}
    ]

    Eag.eval_seq(seq, Env.new())
  end

  def test4 do
    seq = [
      {:match, {:var, :x}, {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
      {:match, {:var, :y}, {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
      {:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}
    ]

    Eag.eval_seq(seq, Env.new())
  end
end
