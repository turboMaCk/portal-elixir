defmodule PortalTest.Door do
  use ExUnit.Case
  doctest Portal.Door

  test "it works" do
    { status, _ } = Portal.Door.start_link(:color)
    assert status == :ok
    assert Portal.Door.get(:color) == []

    Portal.Door.push(:color, :test)
    assert Portal.Door.get(:color) == [:test]

    Portal.Door.pop(:color)
    assert Portal.Door.get(:color) == []
  end
end
