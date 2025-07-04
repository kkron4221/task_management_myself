defmodule TaskManagementMyselfWeb.PersonalController do
  use TaskManagementMyselfWeb, :controller

  def mypage(conn, _params) do
    render(conn, :mypage, current_user: conn.assigns.current_user)
  end
end
