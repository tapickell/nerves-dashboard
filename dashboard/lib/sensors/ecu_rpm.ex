# this is a SIMULATED temperature sensor
# it pretends to get a temperature and sets it into the sensor cache.

defmodule Dashboard.Sensor.EcuRpm do
  use GenServer

  alias Scenic.Sensor

  @name :ecu_rpm
  @version "0.1.0"
  @description "Simulated temperature sensor"

  @timer_ms 200
  @initial_rpm 953
  @amplitude 1.5
  @frequency 0.001
  @tau :math.pi() * 2

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    Sensor.register(:ecu_rpm, @version, @description)
    Sensor.publish(:ecu_rpm, @initial_rpm)

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, ecu_rpm: @initial_rpm, t: 0}}
  end

  def handle_info(:tick, %{ecu_rpm: rpm, t: t} = state) do
    new_rpm = rpm + @amplitude * :math.sin(@tau * @frequency * t)
    Sensor.publish(:ecu_rpm, new_rpm)

    {:noreply, %{state | ecu_rpm: new_rpm, t: t + 1}}
  end
end
