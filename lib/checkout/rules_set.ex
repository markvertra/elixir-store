defmodule OnlineStore.Checkout.RulesSet do
  @moduledoc """
    Model of a rulesset
    - combining products 
    and discount rules
  """

  alias OnlineStore.Checkout.Product
  alias OnlineStore.Checkout.Rules.DiscountRule

  @type products :: [Product.t]
  @type rules :: keyword
  @type opts :: map

  @type t :: %__MODULE__{products: products,
                         rules: rules,
                         opts: opts}

  @enforce_keys [:products, :rules]
  defstruct products: [], rules: [], opts: %{}

  @spec create(products, rules) :: t
  def create(products, rules, opts \\ %{}) do
    %__MODULE__{products: products, rules: rules, opts: opts}
  end

  @spec defaults() :: no_return
  def defaults do
    mug = Product.create!(:mug, "Online Mug", 750)
    tshirt = Product.create!(:tshirt, "Online T-Shirt", 2000)
    voucher = Product.create!(:voucher, "Online Voucher", 500)
    voucher_rule = DiscountRule.create!(2, 1.0, :per_unit)
    tshirt_rule = DiscountRule.create!(3, 0.05, :per_cent)
    create([mug, tshirt, voucher], [mug: nil,
                                    tshirt: tshirt_rule,
                                    voucher: voucher_rule])
  end

  @spec rules_set?(t) :: boolean
  def rules_set?(%__MODULE__{}), do: true
  def rules_set?(_rules), do: false
end
