defmodule TaskManagementMyself.Repo do
  use Ecto.Repo,
    otp_app: :task_management_myself,
    adapter: Ecto.Adapters.Postgres
end
