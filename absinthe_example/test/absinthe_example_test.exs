defmodule AbsintheExampleTest do
  use ExUnit.Case
  doctest AbsintheExample

  test "greets the world" do
    assert AbsintheExample.hello() == :world
  end
end
