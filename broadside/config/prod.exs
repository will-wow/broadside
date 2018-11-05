use Mix.Config

config :broadside, BroadsideWeb.Endpoint,
  load_from_system_env: true,
  # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  http: [port: {:system, "PORT"}],
  # Without this line, your app will not start the web server!
  server: true,
  secret_key_base: "${SECRET_KEY_BASE}",
  # This is critical for ensuring web-sockets properly authorize.
  url: [host: "localhost", port: {:system, "PORT"}]

# Do not print debug messages in production
config :logger, level: :info

config :cors_plug,
  origin: ["https://broadside.surge.sh"],
  max_age: 86400,
  methods: ["GET", "POST"]
