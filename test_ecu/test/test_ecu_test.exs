defmodule TestEcuTest do
  use ExUnit.Case
  doctest TestEcu

  test "greets the world" do
    assert TestEcu.hello() == :world
  end
end
