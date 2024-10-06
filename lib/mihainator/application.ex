defmodule Mihainator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MihainatorWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:mihainator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mihainator.PubSub},
      # Start a worker by calling: Mihainator.Worker.start_link(arg)
      # {Mihainator.Worker, arg},
      # Start to serve requests, typically the last entry
      MihainatorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mihainator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MihainatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
