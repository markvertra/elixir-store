defmodule OnlineStore.Rules.DiscountRule.Test do
  use ExUnit.Case, async: true

  alias OnlineStore.Checkout.Rules.DiscountRule

  test 'can create a valid rule, create!/3' do
    rule = DiscountRule.create!(2, 0.5, :per_unit)
    assert rule == %DiscountRule{minimum: 2, percentage: 0.5, type: :per_unit}
    assert_raise(ArgumentError, 
                 fn -> DiscountRule.create!(
                   0, 0.5, :per_unit
                 ) end)
    assert_raise(ArgumentError,
                 fn -> DiscountRule.create!(
                   3, 1.2, :per_unit
                 ) end)
  end

end