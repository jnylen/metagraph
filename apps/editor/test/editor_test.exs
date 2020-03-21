defmodule EditorTest do
  use ExUnit.Case
  doctest Editor

  test "greets the world" do
    assert Editor.hello() == :world
  end
end
