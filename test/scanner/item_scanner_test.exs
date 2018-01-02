defmodule OnlineStore.Scanner.ItemScanner.Test do
  use ExUnit.Case, async: true

  import OnlineStore.Checkout.Factory
  
  alias OnlineStore.Checkout.Scanner.ItemScanner

  test "if item not in basket, adds to basket, scanner/2" do 
    rules = build(:rules_set)
    assert {{:ok, "MUG"}, [mug: 1]} == ItemScanner.scanner(%{basket: [], 
                                                             rules: rules}, 
                                                             "MUG")
  end

  test "if item already in basket, adds 1 and returns, scanner/2" do
    rules = build(:rules_set)
    {{:ok, "MUG"}, basket} = ItemScanner.scanner(%{basket: [], 
                                                   rules: rules}, 
                                                   "MUG")
    assert {{:ok, "MUG"}, [mug: 2]} == ItemScanner.scanner(%{basket: basket, 
                                                             rules: rules}, 
                                                             "MUG")  
  end

  test "if item not in products list, returns error, scanner/2" do 
    rules = build(:rules_set)
    assert {{:error, "Item not recognised"}, []} == ItemScanner.scanner(%{basket: [], 
                                                                          rules: rules},
                                                                          "FROG")
  end

end