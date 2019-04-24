# frozen_string_literal: true

module KlaviyoAPI
  class Metric < Base
    extend KlaviyoAPI::Support::Countable

    self.prefix += 'v1/'

    self.collection_parser = KlaviyoAPI::Collections::PaginatedCollection

    has_many :events, class_name: 'KlaviyoAPI::Event'

    class << self
      def find_single(scope, options)
        raise KlaviyoAPI::InvalidOperation, 'Cannot get single Metric via API. Please use KlaviyoAPI::Metric#all.'
      end

      def collection_path(prefix_options = {}, query_options = {})
        super prefix_options, query_options.deep_merge({ api_key: headers['api-key'] })
      end

      # Get all Events for all Metrics
      # https://www.klaviyo.com/docs/api/metrics#metrics-timeline
      def events
        KlaviyoAPI::Event.all
      end
    end

    def destroy
      raise KlaviyoAPI::InvalidOperation, 'Cannot delete Metrics via API.'
    end

    def create
      raise KlaviyoAPI::InvalidOperation, 'Cannot create Metrics via API.'
    end

    def update
      raise KlaviyoAPI::InvalidOperation, 'Cannot update Metrics via API.'
    end
  end
end
