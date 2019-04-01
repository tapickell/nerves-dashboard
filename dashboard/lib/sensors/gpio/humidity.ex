defmodule Dashboard.Sensor.Gpio.Humidity do
  use GenServer

  alias Scenic.Sensor

  @name :gpio_humidity
  @version "0.1.0"
  @description "Simulated temperature sensor"

  @timer_ms 40000
  @initial_level 40.0
  @max_level 100
  @min_level 5
  @amplitude 20.5
  @frequency 0.001
  @tau :math.pi() * 2

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, level_to_binary(@initial_level))

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, level: @initial_level, t: 0}}
  end

  def handle_info(:tick, %{level: level, t: t} = state) do
    new_level =
      (level + @amplitude * :math.sin(@tau * @frequency * t))
      |> Float.ceil(0)
      |> trunc()
      |> min(@max_level)
      |> max(@min_level)

    Sensor.publish(
      @name,
      level_to_binary(new_level)
    )

    {:noreply, %{state | level: new_level, t: t + 1}}
  end

  defp level_to_binary(level), do: "#{level}"
end
