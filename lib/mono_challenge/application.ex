defmodule MonoChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MonoChallengeWeb.Telemetry,
      MonoChallenge.Repo,
      {DNSCluster, query: Application.get_env(:mono_challenge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MonoChallenge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MonoChallenge.Finch},
      # Start a worker by calling: MonoChallenge.Worker.start_link(arg)
      # {MonoChallenge.Worker, arg},
      # Start to serve requests, typically the last entry
      MonoChallengeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MonoChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MonoChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
