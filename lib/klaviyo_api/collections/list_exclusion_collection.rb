# frozen_string_literal: true

module KlaviyoAPI::Collections
  class ListExclusionCollection < MarkerCollection
    def next_page_marker_name
      'marker'
    end
  end
end
