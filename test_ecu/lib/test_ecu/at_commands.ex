defmodule TestEcu.AtCommands do
  import Logger

  alias TestEcu.Serial

  @id "ELM327 - TestEcu V0.0.1"
  @desc "TestEcu OBD2, based on ELM"
  # canbus 500k 11 bit protocol id for elm.
  @protocol "6"

  def atatx(command) do
    # ATATx AT2 adaptive time control
    # TODO unsure whats supposed to happen here
    Serial.write_end_ok()
  end

  def atd() do
    with :ok <- Serial.reset_defaults(),
         :ok <- Serial.write("BUS INIT: ...") do
      Serial.write_end_ok()
    end
  end

  def atdesc(_command) do
    with :ok <- Serial.write(@desc) do
      Serial.write_end_ok()
    end
  end

  def atdpn(_command) do
    with :ok <- Serial.write(@protocol) do
      Serial.write_end_ok()
    end
  end

  def atex(<<0x45, switch::binary>>) do
    with :ok <- Serial.set_echo(bool_switch(switch)) do
      Serial.write_end_ok()
    end
  end

  def athx(<<0x48, switch::binary>>) do
    with :ok <- Serial.set_headers(bool_switch(switch)) do
      Serial.write_end_ok()
    end
  end

  def ati() do
    write_id_with_status(:ready)
  end

  def atmx(<<0x4D, switch::binary>>) do
    with :ok <- Serial.set_memory(bool_switch(switch)) do
      Serial.write_end_ok()
    end
  end

  def atlx(<<0x4C, switch::binary>>) do
    with :ok <- Serial.set_line_feeds(bool_switch(switch)) do
      Serial.write_end_ok()
    end
  end

  def atpc(command) do
    # Terminate current diagnostic session, Protocol close
    # TODO unsure whats supposed to happen here
    Serial.write_end_ok()
  end

  def atrv() do
    # Return system voltage
    Serial.write_end_ok()
  end

  def atspx(command) do
    # ATSPx Define protocol 0=auto
    # TODO unsure whats supposed to happen here
    # This is to talk to the auto detect protocol
    # from the ecu
    Serial.write_end_ok()
  end

  def atsx(<<0x53, switch::binary>>) do
    with :ok <- Serial.set_white_spaces(bool_switch(switch)) do
      Serial.write_end_ok()
    end
  end

  def atz() do
    with :ok <- Serial.set_echo(true) do
      write_id_with_status(:idle)
    end
  end

  defp bool_switch(<<0x30>>), do: false
  defp bool_switch(<<0x31>>), do: true

  defp write_id_with_status(status) do
    with :ok <- Serial.set_status(status),
         :ok <- Serial.write(@id) do
      Serial.write_end_ok()
    end
  end

  def commands() do
    %{
      "ATATx" => "AT AT2 adaptative time control",
      "ATD" => "set all to defaults",
      "ATDESC" => "send description",
      "ATDPN" => "set protocol",
      "ATEx" => "set echoEnable 0=off 1=on",
      "ATHx" => "Headers off=0 on=1",
      "ATI" => "Print the version ID",
      "ATLx" => "line feeds off=0 on=1",
      "ATMx" => "set memory off=0 on=1",
      "ATPC" => "Terminates current diagnostic session. Protocol close",
      "ATRV" => "Return system voltage",
      "ATSPx" => "Define protocol 0=auto",
      "ATSx" => "printing spaces off=0 on=1",
      "ATZ" => "reset all",
    }
  end
end
