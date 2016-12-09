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

Behind the scenes, Knit uses [ExConstructor]() to do the magic of converting string maps to
structs, even if the keys are in camelCase. Then Knit uses your types to try to convert
the incoming data to match the schema - and just writes `nil` if it can't.

## Use
First, define a module with a schema. The schema block should return a map with field names
as keys and types as values.
```elixir
defmodule KnitTest.Person do
  use Knit.Model

  schema do
    %{full_name: :string,
      age: :integer,
      is_admin: :boolean,
      favorite_colors: [:string],
      traits: %{map: :boolean},
      eye_color: {:enum, [blue: "blue", green: "green", brown: "brown"]},
      birth_date: KnitTest.DateType,
      address: KnitTest.Address,
      previous_addresses: [KnitTest.Address]}
  end
end

defmodule KnitTest.Address do
  use Knit.Model

  schema do
    %{street: :string,
      city: :string,
      state: :string,
      zip: :string}
  end
end

defmodule KnitTest.DateType do
  use Knit.Type

  def convert(string) when is_binary(string) do
    [year, month, day] = String.split(string, "-")

    %{year: year,
      month: month,
      day: day}
  end
end
```

Then, call `Knit.populate(string_map, Module)` to get a Module struct, populated with the
data from the map.
```elixir
assert Knit.populate(
  %{"full_name" => "Jane",
    "eye_color" => "blue",
    "address" => %{
      "street" => "123 Fake Street",
      "city" => "Luner City Seven",
      "state" => "The Moon",
      "zip" => 99999
    }},
  KnitTest.Person
).address == %KnitTest.Address{
  street: "123 Fake Street",
  city: "Luner City Seven",
  state: "The Moon",
  zip: "99999"
}
```
### Primitives
To type a field as a primitive, use one of these atoms:
- `:string`
- `:integer`
- `:float`
- `:boolean`
- `:any` (to not try to convert the value, even if it's a map of string keys)

### Enums
To define an enum, pass a tuple with `:enum` as the first item and a
keyword list of `final_value: "input_value"`. Note that the input value can be a string
or a number or whatever.

### Nested Structs
To populate a nested struct, define a Knit module for the child, then add the 
module name to the schema.

### Custom types
To define your own custom types, create a module and call `use Knit.Type` in it.
Then define a convert method that takes an input and returns what you want.
Make sure to handle any expected input types, as Knit won't catch any errors in
the conversion.

### Collections
For fields that are a collection of children, make the type a one-item collection
of the appropriate type.
- Lists: `field: [:type]`
- Tuples: `field: {:type}`
- Maps (with string keys): `field: %{map: :type}`
Note that maps must use the key `map`.

## Input Collections
For converting from a list of string maps to a list of knit structs, call 
```elixir
Knit.populate_list([%{"input" => "text"}], ModuleName)
```

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

