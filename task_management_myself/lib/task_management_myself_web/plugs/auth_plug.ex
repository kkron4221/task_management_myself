defmodule TaskManagementMyselfWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias TaskManagementMyself.Accounts

  # Import router helpers for path generation
  use TaskManagementMyselfWeb, :verified_routes

  def fetch_current_user(conn, _opts) do
    user_id = get_session(conn, :user_id)

    if user_id do
      current_user = Accounts.get_user!(user_id)
      assign(conn, :current_user, current_user)
    else
      assign(conn, :current_user, nil)
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end

  # Plug callback functions
  def init(:fetch_current_user), do: :fetch_current_user
  def init(:require_authenticated_user), do: :require_authenticated_user
  def init(:redirect_if_user_is_authenticated), do: :redirect_if_user_is_authenticated

  def call(conn, :fetch_current_user) do
    fetch_current_user(conn, nil)
  end

  def call(conn, :require_authenticated_user) do
    require_authenticated_user(conn, nil)
  end

  def call(conn, :redirect_if_user_is_authenticated) do
    redirect_if_user_is_authenticated(conn, nil)
  end
end
