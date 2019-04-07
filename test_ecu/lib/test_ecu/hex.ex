defmodule TestEcu.Hex do
  defmacro hx(char) do
    quote do
      {n, _} =
        unquote(char)
        |> Base.encode16(case: :lower)
        |> Integer.parse(16)

      n
    end
  end
end
