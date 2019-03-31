defmodule Dashboard.Scene.DemoAll do
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> group(
           fn g ->
             g
             |> text("DemoAll")
           end,
           t: {10, 30}
         )

  def init(_, opts) do

    {:ok, %{graph: @graph}, push: @graph}
  end
end
