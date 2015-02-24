require_relative "spec_helper"

class TestSerializableHashBuilder < Minitest::Test
  def setup
    @resource          = FakeAccount.new
    @representer_class = FakeAccountRepresenter
    @error_class       = Last::Representers::Primitive::InvalidValueError
  end

  def test_to_hash_validates_primitives
    @resource.stub(:id, "string") do
      assert_raises(@error_class) { @representer_class.new(@resource).as_json }
    end
  end
end
