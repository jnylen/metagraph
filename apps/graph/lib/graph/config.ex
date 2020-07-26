defmodule Graph.Config do
  use Skogsra

  @envdoc """
  Graph Hostname.
  """
  app_env :hostname, :graph, :hostname,
    os_env: "GRAPH_HOSTNAME",
    default: "localhost"

  @envdoc """
  Graph port.
  """
  app_env :port, :graph, :port,
    os_env: "GRAPH_PORT",
    default: 9080
end
