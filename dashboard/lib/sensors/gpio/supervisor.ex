defmodule Dashboard.Sensor.Gpio.Supervisor do
  use Supervisor

  alias Dashboard.Sensor.Gpio.{Humidity, Temperature}

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Humidity, nil},
      {Temperature, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
