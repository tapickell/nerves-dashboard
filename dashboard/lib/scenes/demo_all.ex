defmodule Dashboard.Scene.DemoAll do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives
  import Dashboard.Components

  @vp_w 800
  @vp_h 480

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> group(
           fn g ->
             g
             |> ecu_info("EcuInfo")
             |> rect({@vp_w, @vp_h}, stroke: {1, :green})
           end,
           t: {0, 0}
         )
         |> group(
           fn g ->
             g
             |> gpio_info("GpioInfo")
             |> rect({@vp_w, @vp_h}, stroke: {1, :blue})
           end,
           t: {@vp_w + 1, 0}
         )
         |> group(
           fn g ->
             g
             |> text("DemoAll", fill: :gray)
           end,
           t: {0, @vp_h + 20}
         )

  def init(_, _opts) do
    {:ok, %{graph: @graph}, push: @graph}
  end
end
