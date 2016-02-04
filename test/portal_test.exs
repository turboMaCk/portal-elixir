defmodule PortalTest do
  use ExUnit.Case
  doctest Portal

  test "transfer" do
    Portal.Door.start_link(:orange)
    Portal.Door.start_link(:blue)

    portal = Portal.transfer(:orange, :blue, [1, 2, 3])
    assert Portal.Door.get(:orange) == [3, 2, 1]

    Portal.push_right(portal)
    assert Portal.Door.get(:orange) == [2, 1]
    assert Portal.Door.get(:blue) == [3]

    Portal.push_right(portal)
    assert Portal.Door.get(:orange) == [1]
    assert Portal.Door.get(:blue) == [2, 3]

    Portal.push_left(portal)
    assert Portal.Door.get(:orange) == [2, 1]
    assert Portal.Door.get(:blue) == [3]
  end

  test "shoot" do
    assert { :ok, _ } = Portal.shoot(:orange)
    assert { :ok, _ } = Portal.shoot(:blue)

    Portal.transfer(:orange, :blue, [1, 2, 3])
    assert Portal.Door.get(:orange) == [3, 2, 1]
    assert Portal.Door.get(:blue) == []
  end
end
