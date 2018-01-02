defmodule OnlineStore.Checkout.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(rules) do
    Supervisor.start_link(__MODULE__, rules, name: __MODULE__)
  end

  def init(rules) do
    children = [
      worker(OnlineStore.Checkout, [rules])
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
