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
             |> demo_rect("", dims: {@vp_w, @vp_h})
           end,
           t: {0, 0}
         )
         |> group(
           fn g ->
             g
             |> gpio_info("GpioInfo")
             |> demo_rect("", dims: {@vp_w, @vp_h})
           end,
           t: {@vp_w, 0}
         )
         |> group(
           fn g ->
             g
             |> text("DemoAll", fill: :gray, t: {0, 20})
             |> demo_rect("", dims: {@vp_w, @vp_h})
           end,
           t: {0, @vp_h}
         )

  def init(_, _opts) do
    {:ok, %{graph: @graph}, push: @graph}
  end
end
