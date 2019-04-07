defmodule TestEcu.Serial do
  @serial_end_char 0x0D
  @serial_read_timeout 20000

  def reset_defaults do
    :ok
  end

  def set_echo(bool) do
    :ok
  end

  def set_headers(bool) do
    :ok
  end

  def set_line_feeds(bool) do
    :ok
  end

  def set_memory(bool) do
    :ok
  end

  def set_status(status) do
    :ok
  end

  def set_white_spaces(bool) do
    :ok
  end

  def write_end() do
    write(@serial_end_char)
  end

  def write_end_ok() do
    :ok
  end

  def write(char) do
    :ok
  end
end
