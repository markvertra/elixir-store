defmodule OnlineStore.Checkout do
  @moduledoc """
    Genserver module replicating customer facing checkout 
    functionality including scanning items and requesting a total.

    To initiate the checkout, the user must provide a set of
    rules (a RulesSet struct) which defines the available
    products and available discounts to Checkout.start_link

    Alternately, for usability reasons determined in the 
    specs, the same struct can be provided to Checkout.new

    To add items to the checkout:

    Checkout.scan(checkout, item)

    i.e

    Checkout.scan(:checkout42, "WINE")

    To total up items in the checkout:

    Checkout.total(checkout)

  """
  
  use GenServer

  alias OnlineStore.Checkout.Scanner.ItemScanner
  alias OnlineStore.Checkout.Calculator.TotalCalculator
  alias OnlineStore.Checkout.RulesSet

  def new(rules, opts \\ []), do: start_link(rules, opts)

  def start_link(rules, opts \\ [])
  def start_link(%RulesSet{} = rules, opts) do
    GenServer.start_link(__MODULE__, rules, opts)
  end

  def start_link(_rules, _opts) do
    {:error, "Invalid rules set provided"}
  end

  def scan(checkout, prod) do
    GenServer.call(checkout, {:scan, prod})
  end

  def total(checkout) do
    GenServer.call(checkout, :total)
  end

  def destroy(checkout) do
    GenServer.stop(checkout)
  end

  def init(rules) do
    {:ok, %{rules: rules, basket: []}}
  end

  def handle_call({:scan, product}, _from_, state) do
    {message, basket} = ItemScanner.scanner(state, product)

    {:reply, message, Map.put(state, :basket, basket)}
  end

  def handle_call(:total, _from_, state) do
    {:reply, TotalCalculator.total_all(state.basket, state.rules), state}
  end
end
