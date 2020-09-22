# frozen_string_literal: true

module Account
  class Credit < Base
    def debt?
      true
    end

    def nature
      :budget
    end
  end
end
