defmodule OnlineStore.Integrations.Examples.Test do
  use ExUnit.Case, async: true
  
  import OnlineStore.Checkout.Factory

  alias OnlineStore.Checkout

  @rules build(:rules_set)

  test "all 4 examples simultaneously" do
    {:ok, co1} = Checkout.new(@rules)
    {:ok, co2} = Checkout.new(@rules)
    {:ok, co3} = Checkout.new(@rules)
    {:ok, co4} = Checkout.new(@rules)

    assert {:ok, "VOUCHER"} == Checkout.scan(co1, "VOUCHER")
    assert {:ok, "TSHIRT"} == Checkout.scan(co1, "TSHIRT")
    assert {:ok, "MUG"} == Checkout.scan(co1, "MUG")

    assert {:ok, "VOUCHER"} == Checkout.scan(co2, "VOUCHER")
    assert {:ok, "TSHIRT"} == Checkout.scan(co2, "TSHIRT")
    assert {:ok, "VOUCHER"} == Checkout.scan(co2, "VOUCHER")

    assert {:ok, "TSHIRT"} == Checkout.scan(co3, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(co3, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(co3, "TSHIRT")
    assert {:ok, "VOUCHER"} == Checkout.scan(co3, "VOUCHER")
    assert {:ok, "TSHIRT"} == Checkout.scan(co3, "TSHIRT")

    assert {:ok, "VOUCHER"} == Checkout.scan(co4, "VOUCHER")
    assert {:ok, "TSHIRT"} == Checkout.scan(co4, "TSHIRT")
    assert {:ok, "VOUCHER"} == Checkout.scan(co4, "VOUCHER")
    assert {:ok, "VOUCHER"} == Checkout.scan(co4, "VOUCHER")
    assert {:ok, "MUG"} == Checkout.scan(co4, "MUG")
    assert {:ok, "TSHIRT"} == Checkout.scan(co4, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(co4, "TSHIRT")
    
    assert Checkout.total(co1) == "32.50€"
    assert Checkout.total(co2) == "25.00€"
    assert Checkout.total(co3) == "81.00€"
    assert Checkout.total(co4) == "74.50€" 
  end
end
