defmodule Dashboard.Component.DemoRect do
  use Scenic.Component
  alias Scenic.Graph
  alias Scenic.Sensor
  alias Dashboard.Helper.Demo

  require Logger

  import Scenic.Primitives

  def info(data),
    do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
    """

  def verify(label) when is_bitstring(label), do: {:ok, label}
  def verify(_), do: :invalid_data

  def init(_label, options) do
    graph =
      case Application.get_env(:dashboard, :demomode) do
        %{demo: true} ->
          Logger.info("DEMO MODE ACTIVE #{inspect(options)}")
          opts = options[:styles]

          color = Demo.random_color()
          Graph.build()
          |> rect(opts.dims, stroke: {1, color})

        stuff ->
          Logger.info("Not in demo mode: #{inspect(stuff)}")
          Graph.build()
      end

    {:ok, %{graph: graph}, push: graph}
  end
end
