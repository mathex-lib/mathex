defmodule Mathex.Errors.Matrix.InvalidMatrixError do
  @default_message "Invalid matrix input. Use Mathex.Matrix.new/1."

  defexception message: @default_message

  @impl true
  def exception(opts) when is_list(opts) do
    msg = Keyword.get(opts, :message, @default_message)
    %__MODULE__{message: msg}
  end

  def exception(_), do: %__MODULE__{}
end
