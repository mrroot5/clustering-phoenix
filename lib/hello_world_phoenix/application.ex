defmodule HelloWorldPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: HelloWorldPhoenix.ClusterSupervisor]]},
      HelloWorldPhoenixWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:hello_world_phoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloWorldPhoenix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HelloWorldPhoenix.Finch},
      # Start a worker by calling: HelloWorldPhoenix.Worker.start_link(arg)
      # {HelloWorldPhoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      HelloWorldPhoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloWorldPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloWorldPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
