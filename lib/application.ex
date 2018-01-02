defmodule OnlineStore.Application do
  @moduledoc false

  use Application

  alias OnlineStore.Checkout.RulesSet

  @rules RulesSet.defaults()

  def start(_type, _args) do
    children = [
      {OnlineStore.Checkout.Supervisor, @rules}
    ]

    opts = [strategy: :one_for_one, name: OnlineStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
