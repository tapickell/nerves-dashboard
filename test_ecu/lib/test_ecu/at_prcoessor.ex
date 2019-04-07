defmodule TestEcu.AtProcessor do

  alias TestEcu.AtCommands

  require TestEcu.Hex

  import Logger

  @a TestEcu.Hex.hx("A")
  @at TestEcu.Hex.hx("@")
  @c TestEcu.Hex.hx("C")
  @d TestEcu.Hex.hx("D")
  @e TestEcu.Hex.hx("E")
  @h TestEcu.Hex.hx("H")
  @i TestEcu.Hex.hx("I")
  @l TestEcu.Hex.hx("L")
  @m TestEcu.Hex.hx("M")
  @one TestEcu.Hex.hx("1")
  @p TestEcu.Hex.hx("P")
  @s TestEcu.Hex.hx("S")
  @spc TestEcu.Hex.hx(" ")
  @t TestEcu.Hex.hx("T")
  @z TestEcu.Hex.hx("Z")

  def process(command) do
    Logger.info("RX AT: #{command}")

    with {:ok, command_post} <- command_post(command),
         {:ok, response} <- process_command(command_post) do
      Loggger.info("Command #{command} processed")
    end
  end


  defp process_command(command) do
    case command do
      <<@d, _::binary>> -> AtCommands.atd()
      <<@z, _::binary>> -> AtCommands.atz()
      <<@i, _::binary>> -> AtCommands.ati()
      <<@e, _::binary>> -> AtCommands.atex(command)
      <<@l, _::binary>> -> AtCommands.atlx(command)
      <<@m, _::binary>> -> AtCommands.atmx(command)
      <<@s, @p, _::binary>> -> AtCommands.atspx(command)
      <<@s, _::binary>> -> AtCommands.atsx(command)
      <<@h, _::binary>> -> AtCommands.athx(command)
      <<@a, @t, _::binary>> -> AtCommands.atatx(command)
      <<@d, @p, _::binary>> -> AtCommands.atdpn(command)
      <<@d, @e, @s, _::binary>> -> AtCommands.atdesc(command)
      <<@at, @one, _::binary>> -> AtCommands.atdesc(command)
      <<@p, @c, _::binary>> -> AtCommands.atpc(command)
      _ -> {:error, "Unable to process command: #{command}"}
    end
  end

  defp command_post(<<@a, @t, @spc, post::binary>>), do: {:ok, post}
  defp command_post(<<@a, @t, post::binary>>), do: {:ok, post}

  defp command_post(command) do
    {:error, "Unable to process command: #{command}"}
  end

end
