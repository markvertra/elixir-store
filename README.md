# Online Store 

An implementation of an
online store which allowed for selection of certain products,
and for the totalling of these products and the application 
of discounts.

The checkout has a customer facing functionality to scan items,
apply discounts according to set rules, and provide a total to
the user for the items scanned.

To run the examples provided specifically in the Online challenge -

`
mix test test/integrations/examples_test.exs
`

This runs the four examples in one test under four checkouts.

You can also run the Checkout after cloning the repo and installing
dependencies

```elixir
>iex -S mix
Interactive Elixir (1.5.2) - press Ctrl+C to exit (type h() ENTER for help)
iex> alias OnlineStore.Checkout
OnlineStore.Checkout
iex>rules = Checkout.RulesSet.defaults()
...
iex>{:ok, checkout} = Checkout.new(rules)
{:ok, #PID<xxx>}
iex>Checkout.scan(checkout, "MUG")
{:ok, "MUG"}
iex>Checkout.total(checkout)
"7.50€"
```

The default OnlineStore products and rules can also be generated from the 
`defaults` method of `OnlineStore.Checkout.Rules`. I considered setting them 
from Mix.Config, but writing global variables for products and purchase rules
felt like an implementation that would probably later require these variables 
to be ignored, overwritten or modified excessivel.

A supervised genserver is used to manage the checkout state.
upon being scanned items are checked against the rules in the `Itemscanner` module
that they are valid products available for sale and entered into the basket.

Upon asking for a total, the quantity of each item is totalled through the 
checked to see if it exceeds a minimum discount, and then summed by the `TotalCalculator`
module, and converted into a string using the Money Hex package. For this reason, prices
must be entered on product generation as cents. 

Following elixir convention, I tried to keep as much logic as possible out of the
main checkout.ex GenServer module.

## Rules Set

The meta-behaviour of the checkout is determined by a Rules Set struct, containing
available products, with names and prices; and the discount rules to be applied
to each product, as well as optional arguments.

A new Rules Set can be created by calling `OnlineStore.Checkout.RulesSet.create/2`,
returning a rules set struct.

This is the required argument to start a new checkout. The two further public
methods of `RulesSet` are the `rules_set/1` function checks if a struct passed 

is a valid Rules Set, used at Checkout initiation to provide a more user friendly
error message, and the `defaults/0` function, which can generate a default ruleset
identical to that necessary for the OnlineStore Challenge.

## Rules

Although I had originally thought to create each rule as two individual structs,
I instead refined this to apply one rule which acts as a general discount rule. This
rule then has a type, for which the relevant discount logic is applied through
pattern matching when the type is received as a parameter.

To create a new rule `OnlineStore.Checkout.Rules.DiscountRule.create!/3` will
return a discount rule when supplied with:

*  a minimum amount of products for the discount to be applied (which in the per unit discount applies as a divisor) - this must be greater than 0 for a discount
*  a percentage float between 1.0 and 0 - this is the discount to be applied based on
the conditions of the type of discount
*  a type of discount - this is interpreted by the `Calculator`, which uses a `Discount`
module with an `apply/3` function and pattern matching to apply the relvant discount

## Product

A product is a struct with an id, name and price, although in this iteration the name 
is unused and only reflects the information provided in the challenge. 
The id is an itom, and the price an integer in cents (required for proper processing
by `TotalCalculator` and the money package. 

`Product.create!/3` will return a product when supplied with these three values, provided
price is a positive integer. 


## ItemScanner

The `Itemscanner` module simply receives the state of a checkout and an item to be 
scanned. It then checks that that item is a valid product by comparing it against 
the product list passed as rules to the checkout; and if valid, adds the item to the 
basket. Otherwise, an error message is returned to the user.

## Calculator

As mentioned above, the `TotalCalculator` receives a customer basket and then parses
each of the items in the basket, passing it to the `Discount` module which pattern 
matches against the item type to apply any relevant discount and calculate a total price
for each item. A total of totals is then created, turned into a monetary value and
passed back visually to the user.

## Testing

Tests are provided on units and the Online examples act as an end to end test.

*  Dialyxir package was used to check typing
*  Coveralls package was used to ensure test coverage
*  Ex Machina was used to generate factories
*  Credo was used as a linter

## Error handling

Although the Elixir convention is to "let it crash", I decided to handle to
type errors based on user input differently. 

*  An error message is returned if the user attempts to start a checkout with
an invalid rule set.
*  An argument error is raised on attempts to create an invalid product or
invalid discount rule
*  An argument error is rescued in the `ItemScanner` to allow the use of
`String.to_existing_atom/1` whilst persisting the checkout, and provide
relevant info to the user that the scanned product is invalid

If the supervisor is required to restart processes, it does so providing 
the default OnlineStore rulesset (that providing in the challenge) to the 
restarted processes. 

## For future development

Whilst following the instructions provided so as to only replicate the 
behaviours presented in the challenge, it would be simple to add additional
functionality to the `Checkout GenServer`, including clear the checkout; 
change quantities of items in basket and alert customer to discounts when approaching
a minimum threshold.

The `Discount Rules` module was created as one possible type of rule -
other rules could also be created and applied, such as tax rules, daily deals, 
or combo rules, which could then be passed through the calculator at the point of 
calculation, based on their type and family.

I chose not to employ Ecto, Mnesia or anything elixir database wrapper, or indeed
any database, because I saw the decision behind database architecture and interaction
to be beyond the scope of replicating the business logic of the checkout.

Ideally in production, one may want to manage the state of the checkout at
any given moment as a finite state machine, allowing assignations such as
"in process", "cancelled", "purchased", to help better manage processes 
and potentially alide with database storage; persistence 
of customer transaction information; and messaging between processes
and inventory. 



