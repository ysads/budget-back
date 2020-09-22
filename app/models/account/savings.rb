# frozen_string_literal: true

module Account
  class Savings < Base
    def debt?
      false
    end

    def nature
      :tracking
    end
  end
end
