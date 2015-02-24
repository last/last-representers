module Last
module Representers

# Serializes a resource according by a Representer strategy
#
class SerializableHashBuilder < Builder
  def initialize(*, resource:)
    @resource = resource
    super
  end

  # @return [Hash] json strategy
  #
  def to_hash
    store_eligible_subjects_in_output

    validate_values_for_properties!

    output
  end

private

  attr_reader :resource

  def store_eligible_subjects_in_output
    eligible_subjects.each { |subject| store_eligible_subject_in_output(subject) }
  end

  def store_eligible_subject_in_output(subject)
    subject.is_relationship? ? store_relationship_in_output(subject) : store_property_in_output(subject)
  end

  def store_property_in_output(property)
    store(property.name, value_from_resource_for_subject(property))
  end

  def store_relationship_in_output(relationship)
    store(relationship.name, value_for_relationship(relationship))
  end

  # @return [Array<Hash>, Hash]
  #
  def value_for_relationship(relationship)
    relationship.is_list? ? value_for_plural_relationship(relationship) : value_for_singular_relationship(relationship)
  end

  # @return [Array<Hash>]
  #
  def value_for_plural_relationship(relationship)
    resources = value_from_resource_for_subject(relationship)

    resources.map { |resource| serializable_hash_for_subject(relationship, resource) } unless resources.nil?
  end

  # @return [Hash]
  #
  def value_for_singular_relationship(relationship)
    resource = value_from_resource_for_subject(relationship)

    serializable_hash_for_subject(relationship, resource) unless resource.nil?
  end

  # @return [Hash]
  #
  def serializable_hash_for_subject(subject, resource)
    subject.representer.new(resource).as_json(subject.strategy)
  end

  # @return value from method responding to subject.name on resource
  #
  def value_from_resource_for_subject(subject)
    (@_values ||= {})[subject.name] ||= resource.send(subject.name)
  end

  def validate_values_for_properties!
    properties.each { |property| validate_value_for_property!(property) }
  end

  def validate_value_for_property!(property)
    value_for_property = value_from_resource_for_subject(property)
    valid_primitives   = property.primitives.select { |primitive| primitive.valid_for_value?(value_for_property) }

    valid_primitives.any? or raise_invalid_value_error!(property, value_for_property)
  end

  def raise_invalid_value_error!(property, value)
    raise Primitive::InvalidValueError, "Invalid value #{value} or class #{value.class} for property #{property.name}."
  end
end

end
end
