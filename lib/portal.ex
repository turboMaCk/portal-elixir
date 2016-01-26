defmodule Portal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Portal.Door, [])
    ]

    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    for item <- data do
      Portal.Door.push left, item
    end

    # Returns a portal struct we will use next
    %Portal{ left: left, right: right }
  end

  @doc """
  Pushes data to the right in the given `portal`.
  """
  def push_right(portal) do
    push(portal, :right)
  end

  @doc """
  Pushes data to the left in the given `portal`.
  """
  def push_left(portal) do
    push(portal, :left)
  end

  @doc """
  Pushes data to from source `portal` to target `portal`.
  """
  defp push(portal, direction) do
    { target, source } = get_target_and_source_by_direction(portal, direction)

    case Portal.Door.pop(source) do
      :error -> :ok
      { :ok, head } -> Portal.Door.push(target, head)
    end

    # Let's return the portal itself
    portal
  end

  @doc """
  return tuple of source and target for given `portal` and direction
  """
  defp get_target_and_source_by_direction(portal, direction) do
    case direction do
      :left -> { portal.left, portal.right }
      :right -> { portal.right, portal.left }
    end
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end
end

# Inspect Portal struct
defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door  = inspect(left)
    right_door = inspect(right)

    left_data  = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
