# frozen_string_literal: true

module Account
  class Asset < Base
    def debt?
      false
    end

    def nature
      :tracking
    end
  end
end
