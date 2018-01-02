defmodule OnlineStore.Checkout.Supervisor.Test do
  use ExUnit.Case, async: true

  import OnlineStore.Checkout.Factory

  @rules build(:rules_set)

  test "can run multiple checkouts simultaneously, start_link/1" do
    {:ok, co1} = OnlineStore.Checkout.start_link(@rules)
    {:ok, co2} = OnlineStore.Checkout.start_link(@rules)

    assert co1 != co2
  end

end