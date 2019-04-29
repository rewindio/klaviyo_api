# frozen_string_literal: true

module KlaviyoAPI
  class List < Base
    self.prefix += 'v2/'
    self.primary_key = :list_id

    has_many :exclusions, class_name: 'KlaviyoAPI::ListExclusion'

    class << self
      # Override this from ActiveResource#base in order to inject the id into the response
      # because it's not returned
      def find_single(scope, options)
        super.tap { |record| record.id = scope }
      end
    end

    # Gets all Members of this List. Uses the Groups endpoint.
    # Returns an enumerator that knows how to transparently deal
    # with Klaviyo's `marker` for pagination. Pages seem to be
    # 1000 items.
    #
    # https://www.klaviyo.com/docs/api/v2/lists#get-members-all
    def members(options = {})
      KlaviyoAPI::ListMember.all_members params: { list_id: id, **options }
    end
  end
end
