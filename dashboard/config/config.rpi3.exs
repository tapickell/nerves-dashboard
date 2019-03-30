use Mix.Config

config :dashboard, :viewport, %{
  name: :main_viewport,
  # default_scene: {Dashboard.Scene.Crosshair, nil},
  default_scene: {Dashboard.Scene.EcuInfo, nil},
  # default_scene: {Dashboard.Scene.SensorInfo, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Nerves.Rpi
    },
    %{
      module: Scenic.Driver.Nerves.Touch,
      opts: [
        device: "FT5406 memory based driver",
        calibration: {{1, 0, 0}, {1, 0, 0}}
      ]
    }
  ]
}
