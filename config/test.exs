import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mihainator, MihainatorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hLNiTtJYBRTW8rBLs4pbflfTnz1TJbB5ussZ9BcuwW/mH9eXIlPD+2F29b+LC2KB",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :phoenix_test, :endpoint, MihainatorWeb.Endpoint
