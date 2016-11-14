# Knit

Transforms string maps into nested structs: knits strings into something useful.

[Poison](https://github.com/devinus/poison) is great at taking JSON and turning it into
a map with string keys and often string values.

[Ecto](https://github.com/elixir-ecto/ecto) is great at taking those string maps and getting
them ready to put into a database.

But just transforming some structured user data into an Elixir struct
to do something with it other than put it in a database is tricky, particularly if it's nested
data. Knit lets you define your struct as a simple map, and lets you
safely populate that struct without worrying about atom-based DDOS attacks.

## Use
First, define a module with a schema:
```elixir
defmodule KnitTest.Person do
  use Knit.Schema

  schema do
    %{full_name: :string,
      age: :integer,
      is_admin: :boolean,
      favorite_colors: [:string],
      traits: %{map: :boolean},
      address: KnitTest.Address,
      previous_addresses: [KnitTest.Address]}
  end
end

defmodule KnitTest.Address do
  use Knit.Schema

  schema do
    %{street: :string,
      city: :string,
      state: :string,
      zip: :string}
  end
end
```

Then, call `Knit.populate(Module, string_map)` to get a Module struct, populated with the
data from the map.
```elixir
assert Knit.populate(
  KnitTest.Person,
  %{"full_name" => "Jane",
    "address" => %{
      "street" => "123 Fake Street",
      "city" => "Luner City Seven",
      "state" => "The Moon",
      "zip" => 99999
    }}
).address == %KnitTest.Address{
  street: "123 Fake Street",
  city: "Luner City Seven",
  state: "The Moon",
  zip: "99999"
}
```
### Primitives
To type a field as a primitive, use one of these atoms:
- :string
- :integer
- :float
- :boolean
- :any (to not try to convert the value, even if it's a map of string keys)

### Nested Structs
To populate a nested struct, define a Knit module for the child, then add the 
module name to the schema.

### Collections
For fields that are a collection of children, make the type a one-item collection
of the appropriate type.
- Lists: `field: [:type]`
- Tuples: `field: {:type}`
- Maps (with string keys): `field: %{map: :type}`
Note that maps must use the key `map`.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `knit` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:knit, "~> 0.1.0"}]
    end
    ```

  2. Ensure `knit` is started before your application:

    ```elixir
    def application do
      [applications: [:knit]]
    end
    ```

