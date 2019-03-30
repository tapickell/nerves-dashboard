defmodule Dashboard.Component.System do
  use Scenic.Component
  alias Scenic.Graph

  import Scenic.Primitives

  @target System.get_env("MIX_TARGET") || "host"

  @system_info """
  MIX_TARGET: #{@target}
  MIX_ENV: #{Mix.env()}
  Scenic version: #{Scenic.version()}
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
             |> text("Scene")
             |> text("", translate: {10, 18}, font_size: 18, id: :scene_name)
           end,
           t: {10, 150}
         )

  def info(data),
    do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
    """

  def verify(scene_name) when is_bitstring(scene_name), do: {:ok, scene_name}
  def verify(_), do: :invalid_data

  def init(scene_name, options) do
    {:ok, info} = Scenic.ViewPort.info(options[:viewport])

    vp_info = """
    size: #{inspect(Map.get(info, :size))}
    """

    graph =
      @graph
      |> Graph.modify(:vp_info, &text(&1, vp_info))
      |> Graph.modify(:scene_name, &text(&1, scene_name))

    {:ok, %{scene_name: scene_name}, push: graph}
  end
end
