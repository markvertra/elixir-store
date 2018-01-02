defmodule OnlineStore.Checkout.Scanner.ItemScanner do
  @moduledoc """
  Module to check if item is a valid product,
  and if valid add it to basket and return.

  Scanner receives a checkout, and an item to be
  added to it, converts the 
  """

  @type state :: map
  @type item :: String.t
  @type message :: String.t
  @type basket :: keyword
  @type id :: atom

  @spec scanner(state, item) :: {{atom, message}, basket}
  def scanner(state, item) do
    keyword = item_to_atom(item)
    %{basket: basket} = state

    case item_valid(state, keyword) do
      false ->
        {{:error, "Item not recognised"}, basket}

      true ->
        basket = add_to_basket(basket, keyword)
        {{:ok, item}, basket}
    end
  end

  @spec item_valid(basket, atom) :: basket
  defp add_to_basket(basket, product) do
    basket |>
    Keyword.put_new(product, 0) |>
    Keyword.update!(product, &(&1 + 1))
  end

  @spec item_to_atom(item) :: id
  defp item_to_atom(item) when is_binary(item) do
    item |>
    String.downcase() |>
    String.to_existing_atom()
    rescue
      ArgumentError -> false
  end

  defp item_to_atom(_item), do: false

  defp item_valid(_checkout, false), do: false

  @spec item_valid(state, atom) :: atom
  defp item_valid(state, keyword) do
    state[:rules] |>
    Map.get(:products) |>
    Enum.map(fn x -> Map.get(x, :id) end) |>
    Enum.any?(fn x -> x == keyword end)
  end
end
