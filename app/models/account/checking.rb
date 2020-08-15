# frozen_string_literal: true

module Account
  class Checking < Base
    def nature
      :budget
    end
  end
end
