# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::EventCollection do
  describe 'next_page_marker_name' do
    it 'is "since"' do
      assert_equal 'since', KlaviyoAPI::Collections::EventCollection.new.next_page_marker_name
    end
  end
end
