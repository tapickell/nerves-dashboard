defmodule Dashboard.Component.Scene.GpioInfo do
  use Scenic.Component

  alias Scenic.Graph

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @graph_height 60
  @top_margin 30

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> sys_info("GpioInfo")
         |> group(
           fn g ->
             g
             |> simple_gauge("Ambient Temperature", sensor: :gpio_air_temperature, postfix: "°f")
           end,
           t: {280, @top_margin}
         )
         |> group(
           fn g ->
             g
             |> simple_gauge("Humidity Level", sensor: :gpio_humidity, postfix: "% RH")
           end,
           t: {280, @top_margin + @graph_height}
         )
         |> group(
         fn g ->
           g
           |> simple_gauge("Barometric Pressure", sensor: :gpio_barometric_pressure, postfix: "inHG")
         end,
         t: {280, @graph_height * 2 + @top_margin}
         )

  def info(data),
    do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
    """

  def verify(label) when is_bitstring(label), do: {:ok, label}
  def verify(_), do: :invalid_data

  def init(label, _options) do
    Logger.info("#{label} Component init")

    {:ok, %{graph: @graph}, push: @graph}
  end
end
