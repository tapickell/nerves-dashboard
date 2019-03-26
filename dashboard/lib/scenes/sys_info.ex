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
             |> text("IEx")
             |> text(@iex_note, translate: {10, 20}, font_size: 18)
           end,
           t: {10, 240}
         )
         |> group(
          fn g ->
            g
            |> text("Coolant Temperature")
            |> text(
              "",
            id: :temperature,
            translate: {0, 20}
            )
          end,
          t: {340, 240}
         )

  def init(_, opts) do
    {:ok, info} = Scenic.ViewPort.info(opts[:viewport])

    Logger.info "SysInfo init called"

    vp_info = """
    size: #{inspect(Map.get(info, :size))}
    """

    graph = Graph.modify(@graph, :vp_info, &text(&1, vp_info))

    # Sensor.subscribe(:ecu_rpm)
    Sensor.subscribe(:temperature)

    {:ok, %{graph: graph}, push: graph}
  end

  # def handle_info({:sensor, :data, {:ecu_rpm, ecu_rpm, _}}, %{graph: graph}) do
  #   rpm = ecu_rpm
  #   Logger.info "SysInfo handle info for rpm sensor called: #{rpm}"

  #   new_graph = Graph.modify(graph, :ecu_rpm, &text(&1, "#{rpm}"))

  #   {:noreply, %{graph: new_graph}, push: new_graph}
  # end

  def handle_info({:sensor, :data, {:temperature, kelvin, _}}, %{graph: graph}) do
    Logger.info "SysInfo handle info for temp sensor called: #{kelvin}"
    temp = kelvin
    |> :erlang.float_to_binary(decimals: 0)

    new_graph = Graph.modify(graph, :temperature, &text(&1, "#{temp}°"))

    {:noreply, %{graph: new_graph}, push: new_graph}
  end

end
