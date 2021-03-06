defmodule Dashboard.Sensor.Ecu.OilTemperature do
  use GenServer

  alias Scenic.Sensor

  @name :ecu_oil_temperature
  @version "0.1.0"
  @description "Simulated temperature sensor"
  # 5C	92	1	Engine oil temperature	-40	210	°C	{\displaystyle A-40} {\displaystyle A-40}

  @timer_ms 400
  @initial_temp 295.372
  @amplitude 1.5
  @frequency 0.001
  @tau :math.pi() * 2

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, temp_to_binary(@initial_temp))

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, temperature: @initial_temp, t: 0}}
  end

  def handle_info(:tick, %{t: t} = state) do
    temp = @initial_temp + @amplitude * :math.sin(@tau * @frequency * t)

    Sensor.publish(
      @name,
      temp_to_binary(temp)
    )

    {:noreply, %{state | t: t + 1}}
  end

  defp temp_to_binary(temp) do
    :erlang.float_to_binary(temp, decimals: 0)
  end
end
