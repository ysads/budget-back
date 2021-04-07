# frozen_string_literal: true

class ApplicationQuery
  def self.execute(params)
    instance = new(params)
    instance.execute
    instance.relation
  end

  def initialize(params)
    @params = params
    @relation = base_relation
  end

  attr_accessor :params, :relation
end
