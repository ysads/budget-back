# frozen_string_literal: true

module Account
  class Credit < Base
    def nature
      :budget
    end
  end
end
