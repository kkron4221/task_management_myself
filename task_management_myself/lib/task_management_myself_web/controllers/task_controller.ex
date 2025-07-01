defmodule TaskManagementMyselfWeb.TaskController do
  use TaskManagementMyselfWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
