defmodule OnlineStore.Checkout.Calculator.TotalCalculator do
  @moduledoc """
    Module for calculating 
    the total price of a set 
    of products, given an applied
    ruleset.

    Supplying total calculator
    with an item basket, and rules including
    product information and discounting rules
    will return a total.
  """

  alias OnlineStore.Checkout.RulesSet
  alias OnlineStore.Checkout.Calculator.Discount

  @type basket :: keyword
  @type rules_set :: RulesSet.t

  @spec total_all(basket, rules_set) :: String.t
  def total_all(basket, rules) do
    basket |>
    Enum.map(fn x -> item_total(x, rules) end) |>
    Enum.sum() |>
    Kernel.trunc() |>
    Money.new() |>
    Money.to_string()
  end

  @type item :: atom
  @type quantity :: integer
  @type price :: integer

  @spec item_total({item, quantity}, rules_set) :: integer
  defp item_total({item, quantity}, rules) do
    rules |>
    price_identifier(item) |>
    Discount.apply(quantity, Keyword.get(rules.rules, item))
  end

  @spec price_identifier(rules_set, item) :: integer
  defp price_identifier(rules, item) do
    rules.products |>
    Enum.find(fn x -> x.id == item end) |>
    Map.get(:price)
  end
end
