# frozen_string_literal: true

module KlaviyoAPI::Collections
  # This collection is used for item types that rely on
  # markers to provide pagination.
  class MarkerCollection < ActiveResource::Collection
    attr_accessor :count, :marker, :next

    def initialize(response = {})
      # May not exist
      @count = response.delete 'count'

      @next = response['next'] || response['marker']
      @marker = @next

      @elements = response['data'] || response['records'] || []
    end

    def next_page_marker_name
      'marker'
    end

    def more_pages?
      !@next.nil?
    end

    def next_page
      # Return empty collection if no other pages
      return self.class.new unless more_pages?

      first.class.all params: { **first.prefix_options, **original_params, "#{next_page_marker_name}": marker }
    end
  end
end
