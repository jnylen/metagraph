defmodule Api.Router do
  use Api, :router

  forward(
    "/graphiql",
    Absinthe.Plug.GraphiQL,
    schema: Api.Schema,
    interface: :playground
  )

  forward(
    "/api",
    Absinthe.Plug,
    schema: Api.Schema
  )
end
