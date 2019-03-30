defmodule Dashboard.Sensor.Gpio.Humidity do
  use GenServer

  alias Scenic.Sensor

  @name :gpio_humidity
  @version "0.1.0"
  @description "Simulated humidity sensor"

  @timer_ms 40000
  @initial_level 40

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    Sensor.register(@name, @version, @description)
    Sensor.publish(@name, "#{@initial_level}")

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, level: @initial_level, t: 0}}
  end

  def handle_info(:tick, %{t: t} = state) do
    level = 1..100 |> Enum.random()

    Sensor.publish(
      @name,
      "#{level}"
    )

    {:noreply, %{state | t: t + 1}}
  end
end
