# frozen_string_literal: true

class IsoMonth
  def self.of(date)
    if date.is_a?(String)
      Date.parse(date).strftime('%Y-%m')
    else
      date.strftime('%Y-%m')
    end
  end
end
