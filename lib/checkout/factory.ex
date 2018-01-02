defmodule OnlineStore.Checkout.Factory do
  @moduledoc """ 
  Factory for generating products,
  discounts and rule sets for use in
  testing and seeding databases.
  """

  use ExMachina

  alias OnlineStore.Checkout.Product
  alias OnlineStore.Checkout.Rules.DiscountRule
  alias OnlineStore.Checkout.RulesSet

  def product_factory do
    %Product{
      name: "An item",
      id: :item,
      price: "1000",
    }
  end

  def per_unit_discount_factory do
    %DiscountRule{
      minimum: 2,
      percentage: 1,
      type: :per_unit
    }
  end

  def percentage_discount_factory do
    %DiscountRule{
      minimum: 3,
      percentage: 0.05,
      type: :per_cent
    }
  end

  def rules_set_factory do
    mug = build(:product, %{name: "Online Mug", id: :mug, price: 750})
    tshirt = build(:product, %{name: "Online T-Shirt", id: :tshirt, price: 2000})
    voucher = build(:product, %{name: "Online Voucher", id: :voucher, price: 500})
    %RulesSet{
      products: [mug, tshirt, voucher],
      rules: [{:mug, nil},
              {:tshirt, build(:percentage_discount)},
              {:voucher, build(:per_unit_discount)}]
      }
  end
end
