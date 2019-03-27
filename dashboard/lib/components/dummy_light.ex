defmodule Dashboard.Component.DummyLight do
  use Scenic.Component
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives

  @cel "CHECK ENGINE"

  @graph Graph.build()
         |> group(fn g ->
           g
           |> text("", id: :on_state, fill: :orange, t: {0, 0})
         end)

  def info(data),
    do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
    """

  def verify(whatevs) when is_bitstring(whatevs), do: {:ok, whatevs}
  def verify(_), do: :invalid_data

  def init(_whatevs, options) do
    Logger.info("Options keys should contain  #{inspect(options)}")
    _opts = options[:styles]

    Sensor.subscribe(:dummy_light)
    Logger.info("Subscribed to dummy_light")

    state = %{
      graph: @graph,
      on: false
    }

    {:ok, state, push: @graph}
  end

  def handle_info({:sensor, :data, {:dummy_light, on, _}}, %{on: on} = state) do
    Logger.warn("DummyLight HandleInfo matching on_states: #{on}")
    {:noreply, state}
  end

  def handle_info({:sensor, :data, {:dummy_light, data, _}}, %{graph: graph}) do
    Logger.info("handle info for dummy_light sensor called: #{data}")

    new_on = on_from_data(data)

    new_graph =
      graph
      |> Graph.modify(
        :on_state,
        &text(&1, "#{new_on}")
      )

    state = %{
      graph: new_graph,
      on: new_on
    }

    {:noreply, state, push: new_graph}
  end

  defp on_from_data(true), do: @cel
  defp on_from_data(_), do: ""
end
