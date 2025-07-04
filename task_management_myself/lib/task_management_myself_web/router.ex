defmodule TaskManagementMyselfWeb.Router do
  use TaskManagementMyselfWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TaskManagementMyselfWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TaskManagementMyselfWeb.AuthPlug, :fetch_current_user
  end

  pipeline :require_auth do
    plug TaskManagementMyselfWeb.AuthPlug, :require_authenticated_user
  end

  pipeline :redirect_if_authenticated do
    plug TaskManagementMyselfWeb.AuthPlug, :redirect_if_user_is_authenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes
  scope "/", TaskManagementMyselfWeb do
    pipe_through [:browser, :redirect_if_authenticated]

    get "/users/new", UserController, :new
    post "/users", UserController, :create
    get "/login", UserController, :login_form
    post "/login", UserController, :login
  end

  # Protected routes
  scope "/", TaskManagementMyselfWeb do
    pipe_through [:browser, :require_auth]

    get "/tasks", TaskController, :index
    get "/tasks/new", TaskController, :new
    post "/tasks", TaskController, :create
    get "/tasks/:id/edit", TaskController, :edit
    patch "/tasks/:id", TaskController, :update
    delete "/tasks/:id", TaskController, :delete
    get "/mypages", PersonalController, :mypage
    get "/profile", UserController, :profile
    get "/logout", UserController, :logout
  end

  # Public home page
  scope "/", TaskManagementMyselfWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskManagementMyselfWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:task_management_myself, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaskManagementMyselfWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
