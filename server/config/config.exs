# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :server, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:server, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Server",
  ttl: { 15, :minutes },
  exp: { 15, :minutes },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: %{
    "k" => "9un4_QhCI4p6MHxyohcui472opo0se1xjpeD0QMz3hQdaP7aMzFPqKEMSZSZ8EnLdV5nMTEj0wspotL51PrLDA",
    "kty" => "oct"},
  serializer: Server.GuardianSerializer

config :server, Server.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: {:system, :string, "DB_NAME", "server"},
  username: {:system, :string, "DB_USER", "postgres"},
  password: {:system, :string, "DB_PASS", "postgres"},
  port:     {:system, :string, "DB_PORT", "5432"},
  hostname: {:system, :string, "DB_HOST", "localhost"}

config :server,
  ecto_repos: [Server.Repo]
