use Mix.Config

config :scenic_ui, :viewport, %{
  name: :main_viewport,
  # default_scene: {ScenicUi.Scene.Crosshair, nil},
  default_scene: {ScenicUi.Scene.SysInfo, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :scenic_ui"]
    }
  ]
}
