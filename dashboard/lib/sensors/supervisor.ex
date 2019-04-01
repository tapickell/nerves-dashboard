defmodule Dashboard.Sensor.Supervisor do
  use Supervisor

  alias Dashboard.Sensor.Ecu
  alias Dashboard.Sensor.Gpio

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Scenic.Sensor, nil},
      {Ecu.CoolantTemperature, nil},
      {Ecu.DummyLight, nil},
      {Ecu.OilTemperature, nil},
      {Ecu.Rpm, nil},
      # {Ecu.VehicleSpeed, nil},
      {Gpio.AirTemperature, nil},
      {Gpio.Humidity, nil},
      {Gpio.Pressure, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
