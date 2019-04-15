defmodule TestEcu.Serial do
  @serial_end_char 0x0D
  @serial_read_timeout 20000

  # TODO
  # This should have a way of keeping state for the set functions
  # maybe a GenServer it talks to for state storage

  # The set_* / reset_* functions are concerned with managing the ECU options state
  def reset_defaults do
    # what are the defaults?
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

  # The write_* functions are concerned with returning
  # writable data for the serial response

  def write_end() do
    write(@serial_end_char)
  end

  def write_end_ok() do
    # how to compose write_end and write_ok
    :ok
  end

  def write(char) do
    # TODO Do whatever write means to this module
    :ok
  end

  defp write_ok() do
    # What does OK look like to the serial connection?
    :ok
  end

end
