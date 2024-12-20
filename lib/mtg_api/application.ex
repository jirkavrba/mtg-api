defmodule MtgApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MtgApiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:mtg_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MtgApi.PubSub},
      {Cachex, MtgApi.Shops.cache_name()},
      # Start to serve requests, typically the last entry
      MtgApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MtgApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MtgApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
