defmodule Dashboard.Components do
  alias Scenic.Graph
  alias Scenic.Primitive
  alias Scenic.SceneRef

  require Logger

  def simple_gauge(graph, data, options \\ [])

  def simple_gauge(%Graph{} = g, data, options) do
    Logger.info("SimpleGauge add_to_graph helper called: #{inspect(options)}")
    add_to_graph(g, Dashboard.Component.SimpleGauge, data, options)
  end

  def dummy_light(graph, data, options \\ [])

  def dummy_light(%Graph{} = g, data, options) do
    Logger.info("DummyLight add_to_graph helper called: #{inspect(options)}")
    add_to_graph(g, Dashboard.Component.DummyLight, data, options)
  end

  defp add_to_graph(%Graph{} = g, mod, data, options) do
    Logger.info("Components add_to_graph helper called: #{inspect(options)}")
    mod.verify!(data)
    mod.add_to_graph(g, data, options)
  end
end
