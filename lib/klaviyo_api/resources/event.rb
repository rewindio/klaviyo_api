# frozen_string_literal: true

module KlaviyoAPI
  # Klaviyo has the concept of "timelines" on Metrics.
  # A single entry in that timeline is an Event.
  class Event < Base
    ORIGINAL_PREFIX = '/api/v1/metric/:metric_id/'
    self.prefix = ORIGINAL_PREFIX

    self.element_name = 'timeline'
    self.collection_name = 'timeline'
    self.collection_parser = KlaviyoAPI::Collections::NextMarkerCollection

    class << self
      def find_single(scope, options)
        raise KlaviyoAPI::InvalidOperation, 'Cannot get single Event via API. Please use KlaviyoAPI::Event#all.'
      end

      def collection_path(prefix_options = {}, query_options = {})
        # This needs to support both `metrics/timeline` and `metric/<id>/timeline,
        # through `Event.all` and `Event.all params {metric_id: <id>}`. It gets a
        # little messy.
        if prefix_options.empty?
          self.prefix = '/api/v1/metrics/'
        end

        check_prefix_options(prefix_options)

        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options = query_options.deep_merge({ api_key: headers['api-key'] })

        path = "#{prefix(prefix_options)}#{collection_name}#{format_extension}#{query_string(query_options)}"

        self.prefix = ORIGINAL_PREFIX

        path
      end
    end

    def destroy
      raise KlaviyoAPI::InvalidOperation, 'Cannot delete Events via API.'
    end

    def create
      raise KlaviyoAPI::InvalidOperation, 'Cannot create Events via API.'
    end

    def update
      raise KlaviyoAPI::InvalidOperation, 'Cannot update Events via API.'
    end
  end
end
