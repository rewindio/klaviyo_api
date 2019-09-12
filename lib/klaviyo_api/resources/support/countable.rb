# frozen_string_literal: true

module KlaviyoAPI::Support
  module Countable
    def count(params = {})
      all_params = params.deep_merge(params: { count: 1 })
      all(all_params).total
    # klaviyo returns 400 if there are no people/profile in the account, so we catch it and display zero as the total subscribers
    rescue => e
      Nucleus::Logger.warn 'Received a 400 error, returning zero', error: e

      0
    end
  end
end
