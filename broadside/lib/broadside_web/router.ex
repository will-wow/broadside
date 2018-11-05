defmodule BroadsideWeb.Router do
  use BroadsideWeb, :router

  pipeline :api do
    plug :accepts, ["json", "html"]
  end

  scope "/api", BroadsideWeb do
    pipe_through :api

    resources("/users", UserController)
  end
end
