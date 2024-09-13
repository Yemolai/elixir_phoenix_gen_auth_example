defmodule AuthTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthTestWeb.Telemetry,
      AuthTest.Repo,
      {DNSCluster, query: Application.get_env(:auth_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AuthTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AuthTest.Finch},
      # Start a worker by calling: AuthTest.Worker.start_link(arg)
      # {AuthTest.Worker, arg},
      # Start to serve requests, typically the last entry
      AuthTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
