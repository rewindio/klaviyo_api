# frozen_string_literal: true

module KlaviyoAPI::Support
  module Countable
    def count(params = {})
      all_params = params.deep_merge(params: { count: 1 })
      all(all_params).total
    end
  end
end
