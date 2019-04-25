# frozen_string_literal: true

module KlaviyoAPI::Collections
  # This collection is used for item types that rely on pagination and
  # provide `page`, `page_size`, etc.
  class PaginatedCollection < ActiveResource::Collection
    attr_accessor :total, :page, :page_size, :start, :end

    def initialize(response = {})
      @total = response.delete 'total'
      @page = response.delete 'page'
      @page_size = response.delete 'page_size'
      @start = response.delete 'start'
      @end = response.delete 'end'

      @elements = response['data'] || []
    end
  end
end
