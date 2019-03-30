defmodule Dashboard.Sensor.Ecu.Supervisor do
  use Supervisor

  alias Dashboard.Sensor.Ecu.{Rpm, WaterTemperature, DummyLight}

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {DummyLight, nil},
      {Rpm, nil},
      {WaterTemperature, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
