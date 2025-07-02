defmodule TaskManagementMyselfWeb.PersonalController do
  use TaskManagementMyselfWeb, :controller

  def mypage(conn, _params) do
    render(conn, :mypage)
  end
end
