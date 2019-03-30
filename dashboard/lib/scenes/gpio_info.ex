defmodule Dashboard.Scene.GpioInfo do
  use Scenic.Scene
  alias Scenic.Graph

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @graph Graph.build(font_size: 22, font: :roboto_mono)
  |> sys_info("GpioInfo")
  |> group(
  fn g ->
    g
    |> simple_gauge("Ambient Temperature", sensor: :gpio_air_temperature, postfix: "°f")
  end,
  t: {280, 30}
  )
  |> group(
  fn g ->
    g
    |> simple_gauge("Humidity Level", sensor: :gpio_humidity, postfix: "%")
  end,
  t: {340, 240}
  )

  def init(_, opts) do
    {:ok, %{graph: @graph}, push: @graph}
  end
end
