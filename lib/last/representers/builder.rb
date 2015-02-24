module Last
module Representers

class Builder
  def initialize(subjects, strategy, **options)
    @strategy = strategy
    @subjects = subjects
  end

private

  attr_reader :strategy
  attr_reader :subjects
  attr_reader :output

  # @return [Array] subjects eligible for this strategy
  #
  def eligible_subjects
    @_eligible_subjects ||= subjects.select { |subject| subject.is_eligible_for_strategy?(strategy) }
  end

  # @return [Array]
  #
  def properties
    @_properties ||= eligible_subjects.select(&:is_property?)
  end

  # @return [Boolean]
  #
  def has_properties?
    !properties.empty?
  end

  # @return [Array]
  #
  def relationships
    @_relationships ||= eligible_subjects.select(&:is_relationship?)
  end

  # @return [Boolean]
  #
  def has_relationships?
    !relationships.empty?
  end

  # @return [Array]
  #
  def required_subjects
    @_required_subjects ||= eligible_subjects.select(&:is_required?)
  end

  # @return [Boolean]
  #
  def has_required_subjects?
    !required_subjects.empty?
  end

  def store(key, value)
    (@output ||= {}).store(key, value)
  end
end

end
end
