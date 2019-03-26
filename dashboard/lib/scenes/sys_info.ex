defmodule Dashboard.Scene.SysInfo do
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.Sensor

  require Logger

  import Scenic.Primitives

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
             |> text("Input Devices")
             |> text("Devices are being loaded...",
               translate: {10, 20},
               font_size: 18,
               id: :devices
             )
           end,
           t: {280, 30},
           id: :device_list
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

    graph =
      @graph
      |> Graph.modify(:vp_info, &text(&1, vp_info))
      |> Graph.modify(:device_list, &update_opts(&1, hidden: @target == "host"))
      |> push_graph()

    Sensor.subscribe(:temperature)

    {:ok, graph}
  end

  def handle_info({:sensor, :data, {:temperature, kelvin, _}}, graph) do
    Logger.info "SysInfo handle info for sensor called"
    temp = kelvin
    |> :erlang.float_to_binary(decimals: 0)

    graph
    |> Graph.modify(:temperature, &text(&1, "#{temp}°"))
    |> push_graph()

    {:noreply, graph}
  end

end
