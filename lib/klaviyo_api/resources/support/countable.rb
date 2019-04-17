# frozen_string_literal: true

module KlaviyoAPI::Support
  module Countable
    def count(params = {})
      all(params).total
    end
  end
end
