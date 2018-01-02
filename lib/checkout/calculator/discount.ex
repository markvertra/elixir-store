defmodule OnlineStore.Checkout.Calculator.Discount do
  @moduledoc """
    Module for applying discounts for 
    products with a relevant
    discount rule
  """

  alias OnlineStore.Checkout.Rules.DiscountRule

  @type quantity :: integer
  @type price :: integer
  @type discount :: DiscountRule.t

  @spec apply(price, quantity, discount) :: integer
  def apply(price,
            quantity,
            %DiscountRule{
                          minimum: minimum,
                          percentage: percentage,
                          type: :per_cent})
    when quantity >= minimum do
      price * quantity * (1 - percentage)
  end

  def apply(price,
            quantity,
            %DiscountRule{minimum: minimum,
                          percentage: percentage,
                          type: :per_unit})
    when quantity >= minimum do
      discounted = div(quantity, minimum)
      price * (1 - percentage) * discounted + price * (quantity - discounted)
  end

  def apply(price, quantity, _discount_rule), do: price * quantity
end
