defmodule Dashboard.Component.DummyLight do
  use Scenic.Component
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives

  @img_path :code.priv_dir(:dashboard)
            |> Path.join("/static/images/service_engine_soon_pic_2.png")
  @img_hash Scenic.Cache.Support.Hash.file!(@img_path, :sha)
  @width 100
  @height 100
  @on 1.0
  @off 0.2

  @graph Graph.build()
         |> group(fn g ->
           g
           |> rect({@width, @height}, id: :dummy_light, fill: {:image, @img_hash}, t: {15, 230})
         end)

  def info(data),
    do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
    """

  def verify(whatevs) when is_bitstring(whatevs), do: {:ok, whatevs}
  def verify(_), do: :invalid_data

  # maybe this should take the image file
  # instead of the initial on state.
  # the initial state on startup should be off by default
  def init(_whatevs, options) do
    Logger.info("Options keys should contain  #{inspect(options)}")
    _opts = options[:styles]

    Sensor.subscribe(:dummy_light)

    Scenic.Cache.Static.Texture.load(@img_path, @img_hash)

    new_graph =
      Graph.modify(
        @graph,
        :dummy_light,
        &update_opts(&1, fill: {:image, @img_hash, @off})
      )

    state = %{
      graph: new_graph,
      on: false
    }

    {:ok, state, push: new_graph}
  end

  def handle_info({:sensor, :data, {:dummy_light, on, _}}, %{on: on} = state) do
    {:noreply, state}
  end

  def handle_info({:sensor, :data, {:dummy_light, data, _}}, %{graph: graph}) do
    Logger.info("handle info for dummy_light sensor called: #{data}")

    new_on = on_from_data(data)

    new_graph =
      Graph.modify(
        graph,
        :value,
        &update_opts(&1, fill: {:image, @img_hash, alpha_for_toggle(new_on)})
      )

    state = %{
      graph: new_graph,
      on: new_on
    }

    {:noreply, state, push: new_graph}
  end

  defp alpha_for_toggle(true), do: @on
  defp alpha_for_toggle(_), do: @off

  defp on_from_data(on) when is_boolean(on), do: on
  defp on_from_data("true"), do: true
  defp on_from_data(_), do: false
end
