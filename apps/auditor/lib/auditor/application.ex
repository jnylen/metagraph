defmodule Auditor.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    attach_telemetry()

    children = []

    opts = [strategy: :one_for_one, name: Auditor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp attach_telemetry() do
    :telemetry.attach_many(
      "auditor-logger-handler",
      [
        [:dgraph, :item, :insert],
        [:dgraph, :item, :update],
        [:dgraph, :item, :delete]
      ],
      &Auditor.Logger.handle_event/4,
      nil
    )
  end
end
