# frozen_string_literal: true

module Account
  class Cash < Base
    def debt?
      false
    end

    def nature
      :budget
    end
  end
end
