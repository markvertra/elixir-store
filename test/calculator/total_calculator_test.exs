defmodule OnlineStore.Calculator.TotalCalculator.Test do
  use ExUnit.Case, async: true

  import OnlineStore.Checkout.Factory

  alias OnlineStore.Checkout.Calculator.TotalCalculator

  @rules build(:rules_set)

  test "can return the total of a basket item, total_all/2" do
    assert TotalCalculator.total_all([mug: 2], @rules) == "15.00€"
  end

  test "can return the total of multiple basket items, total_all/2" do
    assert TotalCalculator.total_all([mug: 2, tshirt: 2], @rules) == "55.00€"
  end

  test "can return the total of items with different discounts applied, total_all/2" do
    assert TotalCalculator.total_all([mug: 2, tshirt: 3], @rules) == "72.00€"
  end

end