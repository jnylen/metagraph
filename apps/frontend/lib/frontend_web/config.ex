defmodule FrontendWeb.Config do
  use Skogsra

  @envdoc """
  App port.
  """
  app_env :port, :frontend_web, [:http, :port],
    os_env: "FRONTEND_PORT",
    default: 4000

  @envdoc """
  Secret key base.
  """
  app_env :secret_key_base, :frontend_web, :secret_key_base,
    os_env: "FRONTEND_SECRET_KEY_BASE",
    default: "vRuJFscBJw4MwuF1tlDx9UvwBqS3FHGV92QIdesrPMtGkYtoTsmtHFkYJKbX+v9c"
end
