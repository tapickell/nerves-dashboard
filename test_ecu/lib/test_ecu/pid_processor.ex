defmodule TestEcu.PidProcessor do

  @serial_end_char  0x0D
  @serial_read_timeout 20000
  @max_pid 0xFF
  @pid_interval_offset 0x20

  def pids() do
    %{
      "0105" => "Engine coolant temperature",
      "010B" => "Intake manifold abs pressure",
      "010C" => "Engine RPM",
      "010D" => "Vehicle speed",
      "0133" => "Absolute Barometric Pressure",
      "0146" => "Ambient air temperature",
      "015C" => "Engine oil temperature",
      "0170" => "Unsure"
    }
  end

end
