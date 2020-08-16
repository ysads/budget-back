# frozen_string_literal: true

class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  def to_json(*_args)
    Oj.dump(serializable_hash, mode: :compat, time_format: :ruby)
  end
end
