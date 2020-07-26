defmodule Api.Config do
  use Skogsra

  @envdoc """
  App port.
  """
  app_env :port, :api, [:http, :port],
    os_env: "API_PORT",
    default: 4001

  @envdoc """
  Secret key base.
  """
  app_env :secret_key_base, :api, :secret_key_base,
    os_env: "API_SECRET_KEY_BASE",
    default: "vRuJFscBJw4MwuF1tlDx9UvwBqS3FHGV92QIdesrPMtGkYtoTsmtHFkYJKbX+v9c"
end
