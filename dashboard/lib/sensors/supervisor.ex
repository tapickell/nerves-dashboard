defmodule Dashboard.Sensor.Supervisor do
  use Supervisor

  alias Dashboard.Sensor.DummyLight
  alias Dashboard.Sensor.EcuRpm
  alias Dashboard.Sensor.Temperature

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Scenic.Sensor, nil},
      {DummyLight, nil},
      {EcuRpm, nil},
      {Temperature, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
