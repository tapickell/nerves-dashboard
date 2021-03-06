defmodule TestEcu.Listener do
  @moduledoc """
  Listener makes a connection to the UART
  and then listens for :cicuits_uart messages
  """

  use GenServer

  alias Circuits.UART
  alias TestEcu.UartHelper

  import Logger

  # TODO config var
  @port_name "ttyAMA0"

  # API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def close_connection(pid, opts \\ []) do
    GenServer.call(pid, {:close, opts})
  end

  def respond(pid, response) do
    GenServer.call(pid, {:respond, response})
  end

  # Callbacks
  def init(_opts) do
    Logger.info("init called in #{__MODULE__}")

    case UART.start_link() do
      {:ok, pid} ->
        {:ok, %{pid: pid}, {:continue, :connect}}

      {:error, error} ->
        Logger.warn("Could not start UART due to error #{inspect(error)}")
        {:stop, error}
    end
  end

  def handle_continue(:connect, %{pid: pid} = state) do
    case connect_to_port(pid, @port_name) do
      :ok -> {:noreply, state}
      {:error, error} -> {:stop, error}
    end
  end

  def handle_call(:close, %{pid: pid} = state) do
    response = UART.close(pid)
    {:reply, response, state}
  end

  def handle_cast({:respond, response}, %{pid: pid} = state) do
    UART.write(pid, UartHelper.key_to_uart(response))
    {:noreply, state}
  end

  def handle_info({:circuits_uart, _port, {:error, :einval}}, state) do
    """
    Encountered error with serial port communication.
    Stopping Listener.
    Please ensure your device is connected.
    """
    |> Logger.warn()

    {:stop, :normal, state}
  end

  def handle_info({:circuits_uart, _port, data}, %{pid: pid} = state) do
    data = UartHelper.uart_to_printable(data)
    Logger.info("UART Data rcvd: #{data}")
    case TestEcu.Responder.respond(data) do
      {:ok, response} ->
        respond(pid, response)

      {:error, error} ->
        Logger.warn("Error with response from data #{data}: #{error}")
    end

    {:noreply, state}
  end

  # Private
  defp connect_to_port(pid, port_name) do
    options = [speed: 115_200, active: true]

    case UART.open(pid, port_name, options) do
      :ok ->
        :ok

      {:error, error} ->
        Logger.warn("Could not open port #{port_name} due to error #{inspect(error)}")
        {:error, error}
    end
  end

  defp device_connected?(port) do
    UART.enumerate()
    |> IO.inspect(label: "ENUM DEVICES")
    |> Enum.any?(fn {dev, attr} -> dev == port && !Enum.empty?(attr) end)
  end

  # defp live_device_match?({port, %{}}, port), do: false
  # defp live_device_match?({port, _attr}, port), do: true
  # defp live_device_match?(_, _), do: false
end
