defmodule Database.Config do
  use Skogsra

  @envdoc """
  Database URL.
  """
  app_env :url, :database, :url,
    os_env: "DATABASE_URL"

  @envdoc """
  Database pool size.
  """
  app_env :pool_size, :database, :pool_size,
    os_env: "DATABASE_POOL_SIZE",
    default: 10
end
