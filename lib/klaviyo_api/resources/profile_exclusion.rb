# frozen_string_literal: true

require 'addressable/uri'

module KlaviyoAPI
  class ProfileExclusion < Base
    extend KlaviyoAPI::Support::Countable

    self.prefix += 'v1/people/'

    self.element_name = 'exclusion'

    self.collection_parser = KlaviyoAPI::Collections::PaginatedCollection

    class << self
      def collection_path(prefix_options = {}, query_options = {})
        super prefix_options, query_options.deep_merge({ api_key: headers['api-key'] })
      end
    end

    def create
      run_callbacks :create do
        # This endpoint does not accept JSON bodies.

        uri = Addressable::URI.new
        uri.query_values = attributes

        connection
          .post(self.class.collection_path,
                uri.query,
                self.class.headers.merge('Content-Type': 'application/x-www-form-urlencoded'))
          .tap(&method(:load_attributes_from_response))
      end
    end
  end
end
