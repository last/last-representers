require_relative "spec_helper"

class TestPrimitive < Minitest::Test
  def value_is_valid_for_type?(value, type)
    Last::Representers::Primitive.new(type).valid_for_value?(value)
  end

  def test_invalid
    refute value_is_valid_for_type?(1, :array)
  end

  def test_array
    assert value_is_valid_for_type?([1], :array)
  end

  def test_boolean
    assert value_is_valid_for_type?(true,  :boolean)
    assert value_is_valid_for_type?(false, :boolean)
  end

  def test_integer
    assert value_is_valid_for_type?(1, :integer)
  end

  def test_number
    assert value_is_valid_for_type?(100, :number)
    assert value_is_valid_for_type?(1.0, :number)
  end

  def test_null
    assert value_is_valid_for_type?(nil, :null)
  end

  def test_object
    assert value_is_valid_for_type?({}, :object)
  end

  def test_string
    assert value_is_valid_for_type?("string", :string)
    assert value_is_valid_for_type?(:symbol,  :string)
  end
end
