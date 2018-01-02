defmodule OnlineStore.Product.Test do
  use ExUnit.Case, async: true

  alias OnlineStore.Checkout.Product

  test 'can create a valid product, create!/2' do
    product = Product.create!(:mug, "MUG", 2000)
    assert product == %Product{id: :mug, name: "MUG", price: 2000}
    assert_raise(ArgumentError, 
                 fn -> Product.create!(:mug, "MUG", 100.5) end)
  end

end