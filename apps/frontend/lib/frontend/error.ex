defmodule Frontend.Error.NotFound do
  defexception message: "unknown error"
end

defimpl Plug.Exception, for: Frontend.Error.NotFound do
  @spec actions(any) :: []
  def actions(_), do: []

  @spec status(any) :: 404
  def status(_exception), do: 404
end
