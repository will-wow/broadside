defmodule BroadsideWeb.Presence do
  use Phoenix.Presence,
    otp_app: :broadside,
    pubsub_server: Broadside.PubSub
end
