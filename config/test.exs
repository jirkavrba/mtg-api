import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mtg_api, MtgApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "4oxToSJhR0cRy5VvYIu5gDn15dohVgw8WtpR3l2aguhQLerg2f+3jGRKaN3QkqMZ",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
