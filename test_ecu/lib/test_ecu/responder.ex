defmodule TestEcu.Responder do
  # when a pid is read from serial
  # it is processed and a response is written, not sure what maybe like an ACK
  # then response is written with sensor value.

  def respond(data) do
    # TODO implement
    # {:ok, data}
    {:error, "Not implemented"}
  end
end
