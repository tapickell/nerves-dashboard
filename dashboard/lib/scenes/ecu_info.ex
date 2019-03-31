defmodule Dashboard.Scene.EcuInfo do
  use Scenic.Scene
  alias Scenic.Graph

  import Scenic.Primitives
  import Dashboard.Components

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> group(
           fn g ->
             g
             |> ecu_info("EcuInfo")
           end,
           t: {0, 0}
         )

  def init(_, opts) do
    {:ok, %{graph: @graph}, push: @graph}
  end
end
