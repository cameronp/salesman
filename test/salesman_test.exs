defmodule SalesmanTest do
  use ExUnit.Case
  doctest Salesman

  test "greets the world" do
    assert Salesman.hello() == :world
  end
end
