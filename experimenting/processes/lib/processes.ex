defmodule Proc do
  def hello() do
    #:world
    receive do
      x -> IO.inspect("HELLO #{x}")
      #x -> IO.inspect("Test")
      #{:message_type, value} ->
        # code
    end
  end

  def test() do
   receive do
     {:Bye, x} -> IO.inspect("#{:Bye} #{x}")
 end
 end
end
