# frozen_string_literal: true

class ApplicationUseCase
  def self.call(params)
    new(params).call
  end

  protected

  attr_accessor :params
end
