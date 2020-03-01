defmodule Database.Repo do
  use Ecto.Repo,
    otp_app: :database,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
