defmodule Dashboard.Scene.EcuInfo do
  use Scenic.Scene
  alias Scenic.Graph

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> sys_info("EcuInfo")
         |> group(
           fn g ->
             g
             |> simple_gauge("ECU RPM", sensor: :ecu_rpm)
           end,
           t: {280, 30}
         )
         |> group(
           fn g ->
             g
             |> dummy_light("Whatevs")
           end,
           t: {10, 240}
         )
         |> group(
           fn g ->
             g
             |> simple_gauge("Coolant Temperature", sensor: :ecu_coolant_temperature, postfix: "°f")
           end,
           t: {340, 240}
         )

  def init(_, opts) do
    {:ok, info} = Scenic.ViewPort.info(opts[:viewport])

    Logger.info("SysInfo init called")

    vp_info = """
    size: #{inspect(Map.get(info, :size))}
    """

    graph = Graph.modify(@graph, :vp_info, &text(&1, vp_info))

    {:ok, %{graph: graph}, push: graph}
  end
end
