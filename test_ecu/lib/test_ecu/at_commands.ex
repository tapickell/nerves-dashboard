defmodule TestEcu.AtCommands do

  import Logger

  def process(command) do
    Logger.info("RX AT: #{command}")
    with {:ok, command_post} <- command_post(command),
         {:ok, response} <- process_command(command_post) do
      Loggger.info("Command #{command} processed")
    end
  end

  defp process_command(<<hx("D"), _::binary>>), do: atd()
  defp process_command(<<hx("Z"), _::binary>>), do: atz()
  defp process_command(<<hx("I"), _::binary>>), do: ati()
  defp process_command(<<hx("E"), _::binary>> = command), do: atex(command)
  defp process_command(<<hx("L"), _::binary>> = command), do: atlx(command)
  defp process_command(<<hx("M"), _::binary>> = command), do: atmx(command)
  defp process_command(<<hx("S"), hx("P"), _::binary>> = command), do: atspx(command)
  defp process_command(<<hx("S"), _::binary>> = command), do: atsx(command)
  defp process_command(<<hx("H"), _::binary>> = command), do: athx(command)
  defp process_command(<<hx("A"), hx("T"), _::binary>> = command), do: atatx(command)
  defp process_command(<<hx("D"), hx("P"), _::binary>> = command), do: atdpn(command)
  defp process_command(<<hx("D"), hx("E"), hx("S"), _::binary>> = command), do: atdesc(command)
  defp process_command(<<hx("@"), hx("1"), _::binary>> = command), do: atdesc(command)
  defp process_command(<<hx("P"), hx("C"), _::binary>> = command), do: atpc(command)
  defp process_command(command), do: {:error, "Unable to process command: #{command}"}

  defp command_post(<<hx("A"), hx("T"), hx(" "), post::binary>>), do: {:ok, post}
  defp command_post(<<hx("A"), hx("T"), post::binary>>), do: {:ok, post}
  defp command_post(command) do
    {:error, "Unable to process command: #{command}"}
  end

  defp hx(char) do
    {n, _} = char
    |> Base.encode16(case: :lower)
    |> Integer.parse(16)
    n
  end

  def commands() do
    %{
      "ATD" => "set all to defaults",
      "ATZ" => "reset all",
      "ATI" => "Print the version ID",
      "ATEx" => "set echoEnable 0=off 1=on",
      "ATLx" => "line feeds off=0 on=1",
      "ATMx" => "set memory off=0 on=1",
      "ATSPx" => "Define protocol 0=auto",
      "ATSx" => "printing spaces off=0 on=1",
      "ATHx" => "Headers off=0 on=1",
      "ATATx" => "AT AT2 adaptative time control",
      "ATDPN" => "set protocol",
      "ATDESC" => "send description",
      "ATPC" => "Terminates current diagnostic session. Protocol close"
    }
  end

end
