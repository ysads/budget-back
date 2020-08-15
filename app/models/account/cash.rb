# frozen_string_literal: true

module Account
  class Cash < Base
    def nature
      :budget
    end
  end
end
