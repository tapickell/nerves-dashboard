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
  @n TestEcu.Hex.hx("N")
  @one TestEcu.Hex.hx("1")
  @p TestEcu.Hex.hx("P")
  @s TestEcu.Hex.hx("S")
  @spc TestEcu.Hex.hx(" ")
  @t TestEcu.Hex.hx("T")
  @x TestEcu.Hex.hx("X")
  @z TestEcu.Hex.hx("Z")

  def process(command) do
    Logger.info("RX AT: #{command}")

    with {:ok, response} <- process_command(command) do
      Logger.info("Command #{command} processed")
      {:ok, response}
    end
  end


  defp process_command(command) do
    case  command_post(command) do
      {:ok, post} ->
        case post do
          <<@d>> -> {AtCommands.atd(), command}
          <<@z>> -> {AtCommands.atz(), command}
          <<@i>> -> {AtCommands.ati(), command}
          <<@e, @x>> -> {AtCommands.atex(command), command}
          <<@l, @x>> -> {AtCommands.atlx(command), command}
          <<@m, @x>> -> {AtCommands.atmx(command), command}
          <<@s, @p, @x>> -> {AtCommands.atspx(command), command}
          <<@s, @x>> -> {AtCommands.atsx(command), command}
          <<@h, @x>> -> {AtCommands.athx(command), command}
          <<@a, @t, @x>> -> {AtCommands.atatx(command), command}
          <<@d, @p, @n>> -> {AtCommands.atdpn(command), command}
          <<@d, @e, @s, @c>> -> {AtCommands.atdesc(command), command}
          <<@at, @one>> -> {AtCommands.atdesc(command), command}
          <<@p, @c>> -> {AtCommands.atpc(command), command}
          _ -> command_error(command)
        end
      {:error, command, error} -> {:error, command, error}
    end
  end

  defp command_post(<<@a, @t, @spc, post::binary>>), do: {:ok, post}
  defp command_post(<<@a, @t, post::binary>>), do: {:ok, post}
  defp command_post(command), do: command_error(command)

  defp command_error(command) do
    {:error, command, "Unable to process command."}
  end
end
