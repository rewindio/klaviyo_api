# frozen_string_literal: true

module KlaviyoAPI
  class List < Base
    self.prefix += 'v2/'
    self.primary_key = :list_id

    class << self
      # Override this from ActiveResource#base in order to inject the id into the response
      # because its not returned
      def find_single(scope, options)
        super.tap { |record| record.id = scope }
      end
    end
  end
end
