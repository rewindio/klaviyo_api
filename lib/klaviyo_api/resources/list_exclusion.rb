# frozen_string_literal: true

module KlaviyoAPI
  class ListExclusion < Base
    self.prefix += 'v2/list/:list_id/'
    self.element_name = 'exclusions/all'
    self.collection_name = 'exclusions/all'

    self.collection_parser = KlaviyoAPI::Collections::ListExclusionCollection

    class << self
      def find_single(_scope, _options)
        raise KlaviyoAPI::InvalidOperation, 'Cannot get single Exclusion via API. Please use KlaviyoAPI::ListExclusion#all.'
      end
    end

    def destroy
      raise KlaviyoAPI::InvalidOperation, 'Cannot delete ListExclusions via API.'
    end

    def create
      raise KlaviyoAPI::InvalidOperation, 'Cannot create ListExclusions via API.'
    end

    def update
      raise KlaviyoAPI::InvalidOperation, 'Cannot update ListExclusions via API.'
    end
  end
end
