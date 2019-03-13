defmodule NotgenTest do
  use ExUnit.Case
  doctest Notgen

  test "greets the world" do
    assert Notgen.hello() == :world
  end
end
