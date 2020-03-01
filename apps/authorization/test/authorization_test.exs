defmodule AuthorizationTest do
  use ExUnit.Case
  doctest Authorization

  test "greets the world" do
    assert Authorization.hello() == :world
  end
end
