defmodule Dashboard.Sensor.Gpio.Temperature do
  use GenServer

  alias Scenic.Sensor

  @name :gpio_air_temperature
  @version "0.1.0"
  @description "Simulated temperature sensor"

  @timer_ms 40000
  @initial_temp 65.3
  @amplitude 0.5
  @frequency 0.0001
  @tau :math.pi() * 2

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, temp_to_binary(@initial_temp))

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, temperature: @initial_temp, t: 0}}
  end

  # in a real sensor you would use a timer like this to read from a real device.
  # this one just fakes it with a sine wave
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
