use Mix.Config

config :dashboard, :viewport, %{
  name: :main_viewport,
  # default_scene: {Dashboard.Scene.Crosshair, nil},
  default_scene: {Dashboard.Scene.SysInfo, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :dashboard"]
    }
  ]
}
