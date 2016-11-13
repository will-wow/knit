require IEx

defmodule KnitTest.Person do
  # use Knit.Schema
  @behaviour Knit.Model
  defstruct ~w(full_name age favorite_colors address is_admin)a

  def schema do
    [full_name: :string,
     age: :integer,
     is_admin: :boolean,
     favorite_colors: [:string]]
     # address: KnitTest.Address]
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

  # test "generating structs" do
  #   IEx.pry
  #   IO.inspect(%KnitTest.Person{})
  #   assert %KnitTest.Person{}.__struct__
  # end

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

  # test "simple person" do
  #   params = %{"name" => "Bob"}

  #   assert Knit.populate(params, KnitTest.Person) == %KnitTest.SimplePerson{name: "Bob"}
  # end
end
