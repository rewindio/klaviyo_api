# frozen_string_literal: true

module KlaviyoAPI::Collections
  # This collection is used for item types that rely on
  # 'next' markers to provide pagination.
  class NextMarkerCollection < ActiveResource::Collection
    attr_accessor :next, :count

    def initialize(response = {})
      @count  = response.delete 'count'
      @next = response.delete 'next'

      @elements = response['data'] || []
    end
  end
end
