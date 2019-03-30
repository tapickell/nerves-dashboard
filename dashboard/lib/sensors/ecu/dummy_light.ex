defmodule Dashboard.Sensor.DummyLight do
  use GenServer

  alias Scenic.Sensor
  alias Obd2Server.Codes

  @name :dummy_light
  @version "0.1.0"
  @description "Simulated check engine light sensor sends true for on and false for off"

  @timer_ms 42000

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    on_state = false
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, %{on_state: on_state})

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, on_state: on_state, codes: [], t: 0}}
  end

  def handle_info(:tick, %{on_state: true, t: t} = state) do
    new_on_state = false
    Sensor.publish(@name, %{on_state: new_on_state})
    {:noreply, %{state | on_state: new_on_state, t: t + 1}}
  end

  def handle_info(:tick, %{on_state: false, codes: codes, t: t} = state) do
    new_on_state = true
    new_codes = [fetch_error_code() | codes] |> Enum.take(5)
    Sensor.publish(@name, %{on_state: new_on_state, codes: new_codes})
    {:noreply, %{state | on_state: new_on_state, codes: new_codes, t: t + 1}}
  end

  defp fetch_error_code() do
    Codes.Subaru.codes()
    |> Map.keys()
    |> Enum.random()
    |> Codes.Subaru.info_for_code()
  end
end
