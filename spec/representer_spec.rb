require_relative "spec_helper"

require "json-schema"

module RepresenterTests
  def test_json_schema
    assert_equal @json_schema, @expected_json_schema
  end

  def test_as_json
    assert_kind_of String, @serializable_hash
    assert JSON::Validator.validate!(@to_json_schema, @serializable_hash, validate_schema: true)
  end

  def test_as_json_with_list
    assert_kind_of String, @serializable_hash
    assert JSON::Validator.validate!(@to_json_schema, @serializable_hash_for_list, validate_schema: true, list: true)
  end
end

class TestFakeAccountRepresenter < Minitest::Test
  include RepresenterTests

  def setup
    @expected_json_schema       = FakeAccountRepresenter.expected_json_schema_in_full
    @json_schema                = FakeAccountRepresenter.json_schema(:full)
    @to_json_schema             = FakeAccountRepresenter.to_json_schema(:full)
    @serializable_hash          = FakeAccountRepresenter.new(FakeAccount.new).to_json(:full)
    @serializable_hash_for_list = FakeAccountRepresenter.new([FakeAccount.new]).to_json(:full)
  end
end

class TestFakeAdminRepresenter < Minitest::Test
  include RepresenterTests

  def setup
    @expected_json_schema       = FakeAdminRepresenter.expected_json_schema_in_summary
    @json_schema                = FakeAdminRepresenter.json_schema(:summary)
    @to_json_schema             = FakeAdminRepresenter.to_json_schema(:summary)
    @serializable_hash          = FakeAdminRepresenter.new(FakeAdmin.new).to_json(:summary)
    @serializable_hash_for_list = FakeAdminRepresenter.new([FakeAdmin.new]).to_json(:summary)
  end
end
