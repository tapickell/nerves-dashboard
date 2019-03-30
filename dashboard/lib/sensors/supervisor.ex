defmodule Dashboard.Sensor.Supervisor do
  use Supervisor

  # alias Dashboard.Sensor.Ecu
  # alias Dashboard.Sensor.Gpio
  alias Dashboard.Sensor.Gpio.{Humidity, Temperature}
  alias Dashboard.Sensor.Ecu.{Rpm, WaterTemperature, DummyLight}

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Scenic.Sensor, nil},
      {Humidity, nil},
      {Temperature, nil},
      {DummyLight, nil},
      {Rpm, nil},
      {WaterTemperature, nil}
      # {Ecu.Supervisor, nil},
      # {Gpio.Supervisor, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
