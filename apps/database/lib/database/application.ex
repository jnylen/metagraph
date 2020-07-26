defmodule Database.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Database.Config.preload(Database.Repo)

    children = [
      Database.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Database.Supervisor)
  end
end
