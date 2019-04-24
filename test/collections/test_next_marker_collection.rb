# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::NextMarkerCollection do
  it 'finds the data in the raw response' do
    collection = KlaviyoAPI::Collections::NextMarkerCollection.new JSON.parse(load_fixture :next_marker_collection)
    assert_equal 1, collection.size
  end

  it 'sets all pagination attributes' do
    collection = KlaviyoAPI::Collections::NextMarkerCollection.new JSON.parse(load_fixture :next_marker_collection)

    assert_equal 1, collection.count
    assert_equal 'e45ab680-5bb1-11e9-8001-a0dcc2d8d5f1', collection.next
  end
end
