require_relative "spec_helper"

class TestSubject < Minitest::Test
  def setup
    @subject_class = Last::Representers::Subject
    @error_class   = Last::Representers::Primitive::InvalidTypeError
  end

  def test_primitive_type_validation
    assert_raises(@error_class) { @subject_class.new(:example, :property, as: :example) }
  end
end
