module Last
module Representers

class Primitive
  class InvalidTypeError  < StandardError; end
  class InvalidValueError < StandardError; end

  attr_reader :type

  # @see http://json-schema.org/latest/json-schema-core.html#anchor8
  #
  VALID_PRIMITIVES = {
    array:   [Array],
    boolean: [TrueClass, FalseClass],
    integer: [Fixnum],
    number:  [Fixnum, Float],
    null:    [NilClass],
    object:  [Hash],
    string:  [String, Symbol]
  }.freeze

  def initialize(type)
    @type = type

    validate_type!
  end

  # @return [true, false]
  #
  def valid_for_value?(value)
    valid_classes.include?(value.class) or coerceable?(value)
  end

private

  def validate_type!
    valid_primitives.has_key?(type) or raise InvalidTypeError
  end

  # @return [Hash]
  #
  def valid_primitives
    VALID_PRIMITIVES
  end

  # @return [Array]
  #
  def valid_classes
    valid_primitives[type]
  end

  def coerceable?(value)
    true if type == :string && value.to_s
  end
end

end
end
