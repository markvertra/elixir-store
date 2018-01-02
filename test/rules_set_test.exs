defmodule OnlineStore.RulesSet.Test do
  use ExUnit.Case, async: true

  alias OnlineStore.Checkout.RulesSet
  alias OnlineStore.Checkout.Product
  alias OnlineStore.Checkout.Rules.DiscountRule

  import OnlineStore.Checkout.Factory
  

  @product1 build(:product)
  @rule build(:percentage_discount)
  @rules build(:rules_set)

  test 'can create a rules set, create/2' do
    rules = RulesSet.create([@product1], [@rule])
    assert rules.products == [@product1]
  end

  test 'checks if is a valid rules set, rules_set/1' do
    assert RulesSet.rules_set?(@rules)
    assert !RulesSet.rules_set?(%{duck: 42})
  end

  test 'can create default rules set, defaults/0' do
    rules = RulesSet.defaults
    assert rules == %RulesSet{opts: %{}, 
                             products: [%Product{id: :mug, 
                                                 name: "Online Mug", 
                                                 price: 750}, 
                                        %Product{id: :tshirt, 
                                                 name: "Online T-Shirt", 
                                                 price: 2000}, 
                                        %Product{id: :voucher, 
                                                 name: "Online Voucher", 
                                                 price: 500}], 
                             rules: [mug: nil, 
                                    tshirt: %DiscountRule{minimum: 3, 
                                                          opts: [], 
                                                          type: :per_cent, 
                                                          percentage: 0.05}, 
                                    voucher: %DiscountRule{minimum: 2, 
                                                          opts: [], 
                                                          percentage: 1, 
                                                          type: :per_unit}]}
  end
end