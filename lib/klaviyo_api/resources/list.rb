# frozen_string_literal: true

module KlaviyoAPI
  class List < Base
    self.prefix += 'v2/'
    self.primary_key = :list_id

    class << self
      # Override this from ActiveResource#base in order to inject the id into the response
      # because its not returned
      def find_single(scope, options)
        prefix_options, query_options = split_options(options[:params])
        path = element_path(scope, prefix_options, query_options)
        record = instantiate_record(format.decode(connection.get(path, headers).body), prefix_options)
        record.id = scope

        record
      end
    end
  end
end
