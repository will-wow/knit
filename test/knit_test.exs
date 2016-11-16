require IEx

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

defmodule KnitTest do
  use ExUnit.Case, async: true
  doctest Knit

  test "populate simple struct" do
    assert Knit.populate(%{"full_name" => "Sarah"}, KnitTest.Person).full_name == "Sarah"
  end

  test "populate simple struct with camel case key" do
    assert Knit.populate(%{"fullName" => "Sarah"}, KnitTest.Person).full_name == "Sarah"
  end

  test "convert strings to integers" do
    assert Knit.populate(%{"age" => "30"}, KnitTest.Person).age == 30
  end

  test "convert floats to integers" do
    assert Knit.populate(%{"age" => 29.6}, KnitTest.Person).age == 30
  end

  test "convert numbers to strings" do
    assert Knit.populate(%{"full_name" => 5446}, KnitTest.Person).full_name == "5446"
  end
  
  test "convert strings to false" do
    assert Knit.populate(%{"is_admin" => "false"}, KnitTest.Person).is_admin == false
  end

  test "convert arrays of primitives" do
    assert Knit.populate(%{"favorite_colors" => ["olive", 0]}, KnitTest.Person).favorite_colors == ["olive", "0"]
  end

  test "convert enums" do
    assert Knit.populate(%{"eye_color" => "blue"}, KnitTest.Person).eye_color == :blue
  end

  test "convert custom types" do
    assert Knit.populate(%{"birth_date" => "1961-08-04"}, KnitTest.Person).birth_date == %{
      year: "1961",
      month: "08",
      day: "04"
    }
  end

  test "populate nested struc" do
    assert Knit.populate(
      %{"full_name" => "Jane",
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
  end

  test "convert map to list" do
    person = Knit.populate(
      %{"full_name" => "Jane",
        "previous_addresses" => %{
          "0" => %{
            "street" => "123 Fake Street",
            "city" => "Luner City Seven",
            "state" => "The Moon",
            "zip" => 99999},
          "1" => %{
            "street" => "123 Fake Street",
            "city" => "Luner City Seven",
            "state" => "The Moon",
            "zip" => 99999}
        }},
      KnitTest.Person)

    [address | _addresses ] = person.previous_addresses

    assert address == %KnitTest.Address{
      street: "123 Fake Street",
      city: "Luner City Seven",
      state: "The Moon",
      zip: "99999"
    }
  end

  test "handle map of arbitrary keys" do
    assert Knit.populate(
      %{"traits" => %{"cool" => "false",
                      "smart" => "true"}},
      KnitTest.Person
    ).traits == %{"cool" => false, "smart" => true}
  end
end
