# frozen_string_literal: true

class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  def to_json(*_args)
    Oj.dump(serializable_hash.deep_stringify_keys)
  end
end
