defmodule Dashboard.Component.DummyLight do
  use Scenic.Component
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @cel "CHECK ENGINE"

  @graph Graph.build()
         |> group(fn g ->
           g
           |> demo_rect("", dims: {400, 100})
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

    Sensor.subscribe(:ecu_dummy_light)
    Logger.info("Subscribed to dummy_light")

    state = %{
      graph: @graph,
      on: false
    }

    {:ok, state, push: @graph}
  end

  def handle_info({:sensor, :data, {:ecu_dummy_light, %{on_state: on}, _}}, %{on: on} = state) do
    Logger.warn("DummyLight HandleInfo matching on_states: #{on}")
    {:noreply, state}
  end

  def handle_info({:sensor, :data, {:ecu_dummy_light, %{on_state: false}, _}}, %{graph: graph}) do
    Logger.info("handle info for dummy_light sensor called: false")

    new_graph =
      graph
      |> Graph.modify(
        :on_state,
        &text(&1, "")
      )
      |> Graph.delete(:codes_list)

    state = %{
      graph: new_graph,
      on: false
    }

    {:noreply, state, push: new_graph}
  end

  def handle_info({:sensor, :data, {:ecu_dummy_light, %{on_state: true, codes: codes}, _}}, %{
        graph: graph
      }) do
    Logger.info("handle info for dummy_light sensor called: true => #{inspect(codes)}")

    new_graph =
      graph
      |> Graph.modify(
        :on_state,
        &text(&1, "#{@cel}")
      )
      |> list(codes, id: :codes_list, fill: :red, font_size: 14, t: {0, 10})

    state = %{
      graph: new_graph,
      on: true
    }

    {:noreply, state, push: new_graph}
  end
end
