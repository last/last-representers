require "multi_json"

module Last
module Representers

class Representer
  DEFAULT_STRATEGY = :summary.freeze

  def initialize(resource)
    @resource = resource
  end

  def as_json(strategy = default_strategy, builder = SerializableHashBuilder)
    if resource.is_a?(Array)
      resource.map { |resource| builder.new(self.class.subjects, strategy, resource: resource).to_hash }
    else
      builder.new(self.class.subjects, strategy, resource: resource).to_hash
    end
  end

  def to_json(*options)
    MultiJson.dump(as_json(*options))
  end

  # @see Representers::Subject
  #
  def self.expose(*arguments)
    store_subject(Representers::Subject.new(*arguments))
  end

  # @return [Hash] json schema
  #
  def self.json_schema(strategy = default_strategy, builder = JsonSchemaBuilder)
    builder.new(subjects, strategy).to_hash
  end

  # @return [String] json schema
  #
  def self.to_json_schema(*options)
    MultiJson.dump(self.json_schema(*options))
  end

private

  attr_reader :resource

  class << self
    attr_accessor :subjects
  end

  def self.inherited(subclass)
    subclass.subjects = subjects.dup unless subjects.nil?
  end

  # @return [Symbol]
  #
  def default_strategy
    DEFAULT_STRATEGY
  end

  def self.store_subject(subject)
    (@subjects ||= []) << subject
  end
end

end
end
