# frozen_string_literal: true

module KlaviyoAPI::Collections
  class EventCollection < MarkerCollection
    def next_page_marker_name
      'since'
    end
  end
end
