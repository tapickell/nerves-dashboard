defmodule TestEcu.Serial do
  @serial_end_char 0x0D
  @serial_read_timeout 20000

  def write_end() do
    write(@serial_end_char)
  end
end
