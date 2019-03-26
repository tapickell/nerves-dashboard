# a simple supervisor that starts up the Scenic.SensorPubSub server
# and any set of other sensor processes

defmodule Dashboard.Sensor.Supervisor do
  use Supervisor

  alias Dashboard.Sensor.Temperature
  alias Dashboard.Sensor.EcuRpm

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Scenic.Sensor, nil},
      {EcuRpm, nil},
      {Temperature, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
