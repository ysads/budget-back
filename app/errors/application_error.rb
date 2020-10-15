# frozen_string_literal: true

class ApplicationError < StandardError
  def initialize
    super
  end

  def code; end

  def message; end

  def to_h
    {
      code: code,
      message: message,
    }
  end
end
