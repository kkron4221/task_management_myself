defmodule TaskManagementMyself.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Initialize ETS table for task storage
    :ets.new(:tasks_table, [:set, :public, :named_table])

    children = [
      TaskManagementMyselfWeb.Telemetry,
      TaskManagementMyself.Repo,
      {DNSCluster, query: Application.get_env(:task_management_myself, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TaskManagementMyself.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TaskManagementMyself.Finch},
      # Start a worker by calling: TaskManagementMyself.Worker.start_link(arg)
      # {TaskManagementMyself.Worker, arg},
      # Start to serve requests, typically the last entry
      TaskManagementMyselfWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskManagementMyself.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaskManagementMyselfWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
