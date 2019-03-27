defmodule Dashboard.Sensor.DummyLight do
  use GenServer

  alias Scenic.Sensor

  @name :dummy_light
  @version "0.1.0"
  @description "Simulated check engine light sensor sends true for on and false for off"

  @timer_ms 4200

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    on_state = false
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, on_state)

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, on_state: on_state, t: 0}}
  end

  def handle_info(:tick, %{on_state: on_state, t: t} = state) do
    new_on_state = !on_state

    Sensor.publish(@name, new_on_state)

    {:noreply, %{state | on_state: new_on_state, t: t + 1}}
  end
end
