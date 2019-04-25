# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::ListExclusionCollection do
  describe 'next_page_marker_name' do
    it 'is "marker"' do
      assert_equal 'marker', KlaviyoAPI::Collections::ListExclusionCollection.new.next_page_marker_name
    end
  end
end
