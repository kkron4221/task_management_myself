defmodule TaskManagementMyselfWeb.UserController do
  use TaskManagementMyselfWeb, :controller

  alias TaskManagementMyself.Accounts

  def new(conn, _params) do
    changeset = Accounts.change_user(%TaskManagementMyself.Accounts.User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def login_form(conn, _params) do
    render(conn, :login_form)
  end

  def login(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/")

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> render(:login_form)

      {:error, :invalid_password} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> render(:login_form)
    end
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: ~p"/")
  end

  def profile(conn, _params) do
    render(conn, :profile)
  end
end
