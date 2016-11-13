require IEx

defmodule KnitTest.Person do
  # use Knit.Schema
  @behaviour Knit.Model
  defstruct ~w(full_name age favorite_colors address is_admin)a

  def schema do
    [full_name: :string,
     age: :integer,
     is_admin: :boolean,
     favorite_colors: [:string],
     address: KnitTest.Address]
  end
end

defmodule KnitTest.Address do
  # use Knit.Schema
  @behaviour Knit.Model
  defstruct ~w(street city state zip)a

  def schema do
    [street: :string,
     city: :string,
     state: :string,
     zip: :string]
  end
end

defmodule KnitTest do
  use ExUnit.Case, async: true
  doctest Knit

  test "populate simple struct" do
    assert Knit.populate(KnitTest.Person, %{"full_name" => "Sarah"}).full_name == "Sarah"
  end

  test "populate simple struct with camel case key" do
    assert Knit.populate(KnitTest.Person, %{"fullName" => "Sarah"}).full_name == "Sarah"
  end

  test "convert strings to integers" do
    assert Knit.populate(KnitTest.Person, %{"age" => "30"}).age == 30
  end

  test "convert floats to integers" do
    assert Knit.populate(KnitTest.Person, %{"age" => 29.6}).age == 30
  end

  test "convert numbers to strings" do
    assert Knit.populate(KnitTest.Person, %{"full_name" => 5446}).full_name == "5446"
  end
  
  test "convert strings to false" do
    assert Knit.populate(KnitTest.Person, %{"is_admin" => "false"}).is_admin == false
  end

  test "convert arrays of primitives" do
    assert Knit.populate(KnitTest.Person, %{"favorite_colors" => ["olive", 0]}).favorite_colors == ["olive", "0"]
  end

  test "populate nested struc" do
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
  end
end
