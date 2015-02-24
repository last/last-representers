module Last
module Representers

class Subject
  class UnknownKindError < StandardError; end

  STRATEGIES  = {summary: 0, detail: 1, full: 2}.freeze
  VALID_KINDS = [:property, :relationship].freeze

  attr_reader :name
  attr_reader :strategy
  attr_reader :primitives

  # @param name [Symbol]
  # @param kind [Symbol] :property, or :relationship
  #
  # @param keywords [Hash]
  #
  #   @option keywords [Symbol] :in (:detail)
  #     @see STRATEGIES
  #
  #   @option keywords [Array<Symbol>, Symbol] :as ([])
  #     @see VALID_PRIMITIVES
  #
  #   @option keywords [Symbol] :with (:summary)
  #     @see STRATEGIES
  #
  #   @option keywords [Boolean] :required (true)
  #
  #   @option keywords [Boolean] :list (false)
  #
  #   @option keywords [Boolean] :using (false)
  #
  # @example
  #   Subject.new(:hat, :property, in: :summary, as: [:string, :null])
  #
  # @example
  #   Subject.new(:sunglasses, :property, using: GlassesRepresenter)
  #
  # @example
  #   Subject.new(:coat, :property, in: :detail, as: :object)
  #
  # @example
  #   Subject.new(:shoes, :relationship, in: :detail, with: :summary, required: true, list: true)
  #
  def initialize(name, kind, **keywords)
    @name        = name
    @kind        = kind

    @representer = keywords.fetch(:using, false)
    @priority    = keywords.fetch(:in, :detail)
    @strategy    = keywords.fetch(:with, :summary)

    @primitives  = collect_primitives([*keywords.fetch(:as, [])])

    @is_required = keywords.fetch(:required, true)
    @is_list     = keywords.fetch(:list, false)

    validate_kind!
  end

  # @return [Boolean]
  #
  def is_property?
    kind == :property
  end

  # @return [Boolean]
  #
  def is_relationship?
    kind == :relationship
  end

  # @return [Boolean]
  #
  def is_list?
    is_list
  end

  # @return [Boolean]
  #
  def is_required?
    is_required
  end

  # @return [Representer]
  #
  def representer
    @representer.call
  end

  # @return [Boolean]
  #
  def is_eligible_for_strategy?(target_strategy)
    priority <= self.class.priority_for_strategy(target_strategy)
  end

private

  attr_reader :kind
  attr_reader :is_required
  attr_reader :is_list

  # @return [Array]
  #
  def collect_primitives(keys)
    keys.map { |key| Primitive.new(key) }
  end

  # @return [Integer]
  #
  def priority
    @_priority ||= self.class.priority_for_strategy(@priority)
  end

  # @return [Integer]
  #
  def self.priority_for_strategy(strategy)
    strategies[strategy]
  end

  # @return [Hash]
  #
  def self.strategies
    STRATEGIES
  end

  # @return [Boolean] true if valid
  #
  # @raise [UnknownKindError] if invalid
  #
  def validate_kind!
    valid_kinds.include?(kind) or raise UnknownKindError
  end

  # @return [Array]
  #
  def valid_kinds
    VALID_KINDS
  end
end

end
end
