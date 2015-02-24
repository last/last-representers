module Last
module Representers

# JSON Schema Format is defined by JSON Schema Draft 4:
# @see http://tools.ietf.org/html/draft-zyp-json-schema-04
#
# Schemas are validated using JSON Schema:
# @see https://github.com/hoxworth/json-schema
#
class JsonSchemaBuilder < Builder
  # @return [Hash] json schema
  #
  def to_hash
    store_type_in_output
    store_required_subjects_in_output
    store_eligible_subjects_in_output
    store_additional_properties_setting_in_output

    output
  end

private

  def store_type_in_output
    store(:type, [:object, :null])
  end

  def store_required_subjects_in_output
    store(:required, required_subject_names) if has_required_subjects?
  end

  # @return [Array]
  #
  def required_subject_names
    @_required_subject_names ||= required_subjects.map(&:name)
  end

  def store_eligible_subjects_in_output
    store(:properties, eligible_subjects_hash)
  end

  # @return [Hash]
  #
  def eligible_subjects_hash
    @_eligible_subjects_hash ||= eligible_subjects.each_with_object({}) do |subject, hash|
      hash[subject.name] = json_schema_for_subject(subject)
    end
  end

  # @return [Hash]
  #
  def json_schema_for_subject(subject)
    subject.is_relationship? ? json_schema_for_relationship_subject(subject) : json_schema_for_property_subject(subject)
  end

  # @return [Hash]
  #
  def json_schema_for_property_subject(subject)
    {type: subject.primitives.map(&:type) }
  end

  # @return [Hash]
  #
  # @see Representer.json_schema
  #
  def json_schema_for_relationship_subject(subject)
    schema = subject.representer.json_schema(subject.strategy)

    subject.is_list? ? {type: [:array, :null], items: schema} : schema
  end

  def store_additional_properties_setting_in_output
    store(:additionalProperties, false)
  end
end

end
end
