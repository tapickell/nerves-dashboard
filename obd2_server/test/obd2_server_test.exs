defmodule Obd2ServerTest do
  use ExUnit.Case
  doctest Obd2Server

  test "greets the world" do
    assert Obd2Server.hello() == :world
  end
end
