defmodule Dashboard.Component.Scene.EcuInfo do
  use Scenic.Component

  alias Scenic.Graph

  require Logger

  import Scenic.Primitives
  import Dashboard.Components

  @graph_height 60
  @top_margin 30

  @graph Graph.build()
         |> sys_info("EcuInfo")
         |> group(
           fn g ->
             g
             |> simple_gauge("ECU RPM", sensor: :ecu_rpm)
           end,
           t: {280, @top_margin}
         )
         |> group(
           fn g ->
             g
             |> simple_gauge("Coolant Temperature",
               sensor: :ecu_coolant_temperature,
               postfix: "°f"
             )
           end,
           t: {280, @top_margin + @graph_height}
         )
         |> group(
         fn g ->
           g
           |> simple_gauge("Oil Temperature",
           sensor: :ecu_oil_temperature,
           postfix: "°f"
           )
         end,
         t: {280, @graph_height * 2 + @top_margin}
         )
         |> group(
         fn g ->
           g
           |> dummy_light("Whatevs")
         end,
         t: {0, 340}
         )

         # |> group(
         # fn g ->
         #   g
         #   |> simple_gauge("ECU Vehicle Speed",
         #   sensor: :ecu_vehicle_speed,
         #   postfix: "°f"
         #   )
         # end,
         # t: {280, @graph_height * 3 + @top_margin}
         # )

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
