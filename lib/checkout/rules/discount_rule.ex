defmodule OnlineStore.Checkout.Rules.DiscountRule do
  @moduledoc """
    Model of a per unit discount

    i.e a discount of 0.5 with a minimum of 3 would mean
    that for every 3 sales a 50% discount
    would be applied to the third item. 
  """

  @typedoc """ 
  type representing a per unit discount
  """

  @type minimum :: integer
  @type percentage :: float
  @type type :: atom

  @type t :: %__MODULE__{minimum: minimum,
                         percentage: percentage,
                         type: atom}

  @enforce_keys [:minimum, :percentage, :type]
  defstruct [:minimum, :percentage, :type, family: :discount, opts: []]

  @spec create!(minimum, percentage, type) :: t
  def create!(minimum, percentage, type)
    when percentage >= 0 and percentage <= 1 and minimum > 0 do
      %__MODULE__{minimum: minimum, percentage: percentage, type: type}
  end

  def create!(_minimum, _percentage, _type), do: raise ArgumentError
end
