# frozen_string_literal: true

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

      def element_path(id, prefix_options = {}, query_options = {})
        super id, prefix_options, query_options.deep_merge({ api_key: headers['api-key'] })
      end
    end
  end
end
