defmodule TestEcu.UartHelper do
  def uart_to_printable(data) do
    for <<c <- data>>, into: "", do: make_printable(c)
  end

  defp make_printable(0), do: <<>>
  defp make_printable(?\a), do: <<>>
  defp make_printable(?\b), do: IO.ANSI.cursor_left()
  defp make_printable(other), do: <<other>>

  defp key_to_uart(10), do: <<?\r, ?\n>>
  defp key_to_uart(127), do: <<?\b>>
  defp key_to_uart(key), do: <<key>>
end
