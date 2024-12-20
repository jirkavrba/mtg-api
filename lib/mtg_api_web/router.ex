defmodule MtgApiWeb.Router do
  use MtgApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MtgApiWeb do
    get "/", HomeController, :index
    options "/*path", HomeController, :options
  end

  scope "/api", MtgApiWeb do
    pipe_through :api

    post "/shops/card", ShopsController, :card
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:mtg_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: MtgApiWeb.Telemetry
    end
  end
end
