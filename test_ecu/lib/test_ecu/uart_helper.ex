defmodule TestEcu.UartHelper do
  def uart_to_printable(data) do
    for <<c <- data>>, into: "", do: make_printable(c)
  end

  def make_printable(0), do: <<>>
  def make_printable(?\a), do: <<>>
  def make_printable(?\b), do: IO.ANSI.cursor_left()
  def make_printable(other), do: <<other>>

  def key_to_uart(10), do: <<?\r, ?\n>>
  def key_to_uart(127), do: <<?\b>>
  def key_to_uart(key), do: <<key>>
end
