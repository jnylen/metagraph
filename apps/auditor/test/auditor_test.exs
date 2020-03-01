defmodule AuditorTest do
  use ExUnit.Case
  doctest Auditor

  test "greets the world" do
    assert Auditor.hello() == :world
  end
end
