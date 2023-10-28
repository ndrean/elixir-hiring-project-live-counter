defmodule LiveviewCounter.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # start_users_ets()

    topologies = [
      epdm: [
        strategy: Cluster.Strategy.LocalEpmd
        # config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]],
        # connect: {:net_kernel, :connect_node, []},
        # disconnect: {:erlang, :disconnect_node, []},
        # list_nodes: {:erlang, :nodes, [:connected]}
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: LiveViewCounter.ClusterSupervisor]]},
      Counter.Repo,
      LiveviewCounterWeb.Telemetry,
      LiveviewCounterWeb.Endpoint,
      {Phoenix.PubSub, name: LiveviewCounter.PubSub},
      LiveviewCounter.Count,
      LiveviewCounter.Presence
    ]

    opts = [strategy: :one_for_one, name: LiveviewCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LiveviewCounterWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # def start_users_ets do
  #   :users = :ets.new(:users, [:set, :public, :named_table])
  # end
end
