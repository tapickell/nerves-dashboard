defmodule Dashboard.Component.SimpleGauge do
  use Scenic.Component
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @moduledoc """
  Add a Simple Gauge to a graph

  ## Data

  `label`

  * `label` - a bitstring describing the text to show above the value readout

  ### Example
      graph
      |> simple_gauge("Water Temperature", sensor: :water_temperature, postfix: "°f")
  """

  @graph Graph.build()
         |> group(fn g ->
           g
           |> text("", id: :label)
           |> text("", id: :value, translate: {0, 20})
           |> demo_rect("", dims: {400, 100})
         end)

  def info(data),
    do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
    """

  def verify(label) when is_bitstring(label), do: {:ok, label}
  def verify(_), do: :invalid_data

  def init(label, options) do
    Logger.info("Options keys should contain :sensor #{inspect(options)}")
    opts = options[:styles]
    sensor = opts[:sensor]
    pf = opts[:postfix] || ""
    Logger.info("SimpleGauge init called with sensor: #{sensor} from")

    graph = Graph.modify(@graph, :label, &text(&1, label))

    if sensor do
      Logger.info("SimpleGauge Sensor subscribe called with sensor: #{sensor}")
      Sensor.subscribe(sensor)
    end

    state = %{
      graph: graph,
      label: label,
      postfix: pf,
      sensor: sensor
    }

    {:ok, state, push: graph}
  end

  def handle_info(
        {:sensor, :data, {sensor, data, _}},
        %{graph: graph, postfix: pf, sensor: sensor} = state
      ) do
    Logger.info("handle info for #{sensor} sensor called: #{data}")

    new_graph = Graph.modify(graph, :value, &text(&1, "#{data}#{pf}"))

    {:noreply, %{state | graph: new_graph}, push: new_graph}
  end
end
