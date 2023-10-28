defmodule LiveviewCounterWeb.Router do
  use LiveviewCounterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveviewCounterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug :put_user_token
  end

  # defp put_user_token(conn, _) do
  #   id = Enum.random(0..1000)
  #   token = Phoenix.Token.sign(conn, "user socket", id)

  #   require Logger

  #   Logger.debug(
  #     "Starting connection: user: #{id}, from region: #{System.get_env("FLY_REGION")}-----------"
  #   )

  #   :ets.insert(:users, {:id, id, :authorized})
  #   assign(conn, :user_token, token)
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveviewCounterWeb do
    pipe_through :browser
    live "/", Counter

    # get "/", PageController, :home
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:liveview_counter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveviewCounterWeb.Telemetry
    end
  end
end
