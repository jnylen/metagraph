use Mix.Config

config :authorization, Authorization.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  issuer: "Metagraph",
  ttl: {30, :days},
  allowed_drift: 2000,
  # optional
  verify_issuer: true,
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "4Cg2QCFvSq5Xuh47mYCiEw", "kty" => "oct"},
  serializer: Authorization.Guardian
