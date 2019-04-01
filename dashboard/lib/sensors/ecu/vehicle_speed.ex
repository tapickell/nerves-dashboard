# defmodule Dashboard.Sensor.Ecu.VehicleSpeed do
#   use GenServer

#   alias Scenic.Sensor

#   @name :ecu_vehicle_speed
#   @version "0.1.0"
#   @description "Simulated ecu speed sensor"
#   # 0D	13	1	Vehicle speed	0	255	km/h	{\displaystyle A} A

#   @max_speed 85
#   @min_speed 0
#   @timer_ms 2000
#   @amplitude 20.5
#   @frequency 0.001
#   @tau :math.pi() * 2

#   def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

#   def init(_) do
#     Sensor.register(@name, @version, @description)
#     Sensor.publish(@name, @min_speed)

#     {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
#     {:ok, %{timer: timer, ecu_speed: @min_speed, t: 0}}
#   end

#   def handle_info(:tick, %{ecu_speed: speed, t: t} = state) do
#     new_speed =
#       (speed + @amplitude * :math.sin(@tau * @frequency * t))
#       |> Float.ceil(0)
#       |> trunc()
#       |> min(@max_speed)
#       |> max(@min_speed)

#     Sensor.publish(@name, new_speed)

#     {:noreply, %{state | ecu_speed: new_speed, t: t + 1}}
#   end
# end
