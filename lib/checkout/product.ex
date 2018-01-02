defmodule OnlineStore.Checkout.Product do
  @moduledoc """
    Model of a product
    - with a name, code
    and price
  """

  @typedoc """ 
  type representing a purchaseable product 
  """

  @type id :: atom
  @type name :: String.t
  @type price :: integer

  @type t :: %__MODULE__{id: id, name: name, price: price}

  @enforce_keys [:id, :name, :price]
  defstruct [:id, :name, :price]

  @spec create!(id, name, price) :: t
  def create!(id, name, price)
    when is_integer(price) and price >= 0 do
      %__MODULE__{id: id, name: name, price: price}
  end

  def create!(_id, _name, _price), do: raise ArgumentError
end
