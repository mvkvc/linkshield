defmodule LinkShield.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LinkShieldWeb.Telemetry,
      LinkShield.Repo,
      {DNSCluster, query: Application.get_env(:linkshield, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LinkShield.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LinkShield.Finch},
      # Start a worker by calling: LinkShield.Worker.start_link(arg)
      # {LinkShield.Worker, arg},
      # Start to serve requests, typically the last entry
      LinkShieldWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkShield.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinkShieldWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
