defmodule ClusteringPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: ClusteringPhoenix.ClusterSupervisor]]},
      ClusteringPhoenixWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:clustering_phoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ClusteringPhoenix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ClusteringPhoenix.Finch},
      # Start a worker by calling: ClusteringPhoenix.Worker.start_link(arg)
      # {ClusteringPhoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      ClusteringPhoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClusteringPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClusteringPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
