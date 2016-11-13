require IEx

defmodule KnitTest.SimplePerson do
  # use Knit.Schema
  @behaviour Knit.Model
  defstruct ~w(full_name age is_admin)a

  def schema do
    [full_name: :string,
     age: :integer]
  end
end

defmodule KnitTest.Person do
  # use Knit.Schema
  @behaviour Knit.Model
  defstruct ~w(full_name age address)a

  def schema do
    [full_name: :string,
     age: :integer,
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
  #   IO.inspect(%KnitTest.SimplePerson{})
  #   assert %KnitTest.SimplePerson{}.__struct__
  # end

  test "populate simple struct" do
    assert Knit.populate(KnitTest.SimplePerson, %{"full_name" => "Sarah"}).full_name == "Sarah"
  end

  test "populate simple struct with camel case key" do
    assert Knit.populate(KnitTest.SimplePerson, %{"fullName" => "Sarah"}).full_name == "Sarah"
  end

  test "convert strings to integers" do
    assert Knit.populate(KnitTest.SimplePerson, %{"age" => "30"}).age == 30
  end

  test "convert floats to integers" do
    assert Knit.populate(KnitTest.SimplePerson, %{"age" => 29.6}).age == 30
  end

  test "convert numbers to strings" do
    assert Knit.populate(KnitTest.SimplePerson, %{"full_name" => 5446}).full_name == "5446"
  end
  
  test "convert strings to false" do
    assert Knit.populate(KnitTest.SimplePerson, %{"full_name" => 5446}).full_name == "5446"
  end

  # test "simple person" do
  #   params = %{"name" => "Bob"}

  #   assert Knit.populate(params, KnitTest.SimplePerson) == %KnitTest.SimplePerson{name: "Bob"}
  # end
end
