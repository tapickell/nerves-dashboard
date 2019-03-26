defmodule Dashboard.Component.SimpleGauge do
  use Scenic.Component
  alias Scenic.Graph
  alias Scenic.Sensor

  import Scenic.Primitives, only: [{:text, 3}]

  @graph Graph.build()
  |> group(
    fn g ->
      g
      |> text("", id: :label)
      |> text("", id: :value, translate: {0, 20})
    end
  )

  def info(data), do: """
  #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
  #{IO.ANSI.yellow()}Received: #{inspect(data)}
  #{IO.ANSI.default_color()}
  """
  def verify(label) when is_bitstring(label), do: {:ok, label}
  def verify(_), do: :invalid_data

  def init(label, value // "", sensor: sensor, postfix: postfix) do
    p = postfix || ""

    graph = @graph
    |> Graph.modify(:label, &label(&1, label))
    |> Graph.modify(:value, &value(&1, "#{value}#{p}"))

    if sensor, do: Sensor.subscribe(sensor)

    state = %{
      graph: graph,
      label: label,
      postfix: postfix,
      sensor: sensor,
      value: value
    }

    {:ok, state, push: graph}
  end

  def handle_info({:sensor, :data, {sensor, data, _}}, %{graph: graph, postfix: pf, sensor: sensor}) do
    Logger.info "handle info for #{sensor} sensor called: #{data}"

    new_graph = Graph.modify(graph, :value, &text(&1, "#{data}#{pf}"))

    {:noreply, %{graph: new_graph}, push: new_graph}
  end
end
