defmodule OnlineStore.Checkout.Test do
  use ExUnit.Case, async: true

  import OnlineStore.Checkout.Factory
  alias OnlineStore.Checkout
  @rules build(:rules_set)

  test "starts checkout, start_link/1" do 
    {check, _checkout} = Checkout.start_link(@rules)
    assert check == :ok
  end

  test "starts checkout with invalid rules, start_link/1" do
    {check, _checkout} = Checkout.start_link(%{ducks: 42})
    assert check == :error
  end

  test "scans valid item with no discount, scan/2" do
    {:ok, checkout} = Checkout.start_link(@rules)
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
  end

  test "returns total, total/1" do
    {:ok, checkout} = Checkout.start_link(@rules)
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
    assert Checkout.total(checkout) == "40.00€"
  end 

  test "ends checkout, destroy/1" do
    {:ok, checkout} = Checkout.start_link(@rules)
    assert Checkout.destroy(checkout) == :ok
  end

  test "scan items with relevant discount and return total, scan/2, total/1" do
    {:ok, checkout} = Checkout.start_link(@rules)
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
    assert {:ok, "TSHIRT"} == Checkout.scan(checkout, "TSHIRT")
    assert Checkout.total(checkout) == "57.00€"
  end  
end