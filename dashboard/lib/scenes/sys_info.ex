defmodule Dashboard.Scene.SysInfo do
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @target System.get_env("MIX_TARGET") || "host"

  @system_info """
  MIX_TARGET: #{@target}
  MIX_ENV: #{Mix.env()}
  Scenic version: #{Scenic.version()}
  """

  @iex_note """
  Please note: because Scenic draws over
  the entire screen in Nerves, IEx has
  been routed to the UART pins.
  """

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> group(
           fn g ->
             g
             |> text("System")
             |> text(@system_info, translate: {10, 20}, font_size: 18)
           end,
           t: {10, 30}
         )
         |> group(
           fn g ->
             g
             |> text("ViewPort")
             |> text("", translate: {10, 20}, font_size: 18, id: :vp_info)
           end,
           t: {10, 110}
         )
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
             |> text("Codes")
             |> text(@iex_note, translate: {10, 20}, font_size: 18)
             |> dummy_light("Whatevs")
           end,
           t: {10, 240}
         )
         |> group(
           fn g ->
             g
             |> simple_gauge("Coolant Temperature", sensor: :temperature, postfix: "°f")
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
