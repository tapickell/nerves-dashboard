defmodule TestEcu.Listener do
  use GenServer

  alias TestEcu.UartHelper

  import Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(opts) do

    case UART.start_link() do
      {:ok, pid} ->
        {:ok, %{pid: pid, tries: 0}, {:continue, :connect}}
      {:error, error} ->
        Logger.warn("Could not start UART due to error #{inspect(error)}")
        {:stop, error}
    end
  end

  def handle_continue(:connect, %{pid: pid, tries: tries} = state) do
    port_name = "ttyS0" # TODO move to config
    if device_connected?(port_name) do
      case connect_to_port(pid, port_name) do
        :ok -> {:ok, state}
        {:error, error} -> {:stop, error}
      end
    else
      if tries <= 3 do
        Logger.info("No connected device for try: #{tries}, trying again")
        {:noreply, %{state | tries: tries + 1}, {:continue, :connect}}
      else
        {:stop, "Unable to find device connected to #{port_name}"}
      end
    end
  end

  def close_connection(pid, opts \\ []) do
    GenServer.call(pid, {:close, opts})
  end

  def handle_call(:close, %{pid: pid} = state) do
    response = Circuits.UART.close(pid)
    {:reply, response, state}
  end

  def respond(pid, response) do
    GenServer.call(pid, {:respond, response})
  end

  def handle_cast({:respond, response}, %{pid: pid} = state) do
    UART.write(pid, UartHelper.key_to_uart(response))
    {:noreply, state}
  end

  def handle_cast({:reply, char}, %{pid: pid} = state) do
    UART.write(pid, UartHelper.key_to_uart(char))
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

  def handle_info({:circuits_uart, _port, data}, state) do
    data = UartHelper.uart_to_printable(data)
    # what to do from here?
    # verify data is expected command or query
    # send that to handler for command or query
    # return reply via UART.write
    {:noreply, state}
  end

  defp connect_to_port(pid, port_name) do
    options = [speed: 115_200, active: true]
    case UART.open(pid, port_name, options) do
      :ok -> :ok

      {:error, error} ->
        Logger.warn("Could not open port #{port_name} due to error #{inspect(error)}")
        {:error, error}
    end
  end

  defp device_connected?(port) do
    Circuits.UART.enumerate()
    |> Enum.any?(fn {dev, attr} -> dev == port && !Enum.empty(attr) end)
  end

  # defp live_device_match?({port, %{}}, port), do: false
  # defp live_device_match?({port, _attr}, port), do: true
  # defp live_device_match?(_, _), do: false

end
