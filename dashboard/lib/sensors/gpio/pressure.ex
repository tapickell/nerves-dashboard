defmodule Dashboard.Sensor.Gpio.Pressure do
  use GenServer

  alias Scenic.Sensor

  @name :gpio_barometric_pressure
  @version "0.1.0"
  @description "Simulated pressure sensor"

  @max_level 30.5
  @min_level 29.5
  @timer_ms 40000
  @initial_temp 30.0
  @amplitude 0.5
  @frequency 0.001
  @tau :math.pi() * 2

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, temp_to_binary(@initial_temp))

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, temp: @initial_temp, t: 0}}
  end

  def handle_info(:tick, %{temp: temp, t: t} = state) do
    new_temp = temp + @amplitude * :math.sin(@tau * @frequency * t)
    |> min(@max_level)
    |> max(@min_level)

    Sensor.publish(
      @name,
      temp_to_binary(new_temp)
    )

    {:noreply, %{state | temp: new_temp, t: t + 1}}
  end

  defp temp_to_binary(temp) do
    :erlang.float_to_binary(temp, decimals: 2)
  end
end
