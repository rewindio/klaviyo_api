# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::MarkerCollection do
  it 'finds the data in the "data" field' do
    collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:next_collection)
    assert_equal 1, collection.size
  end

  it 'recognizes "next" markers' do
    collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:next_collection)

    assert_equal 1, collection.count
    assert_equal 'e45ab680-5bb1-11e9-8001-a0dcc2d8d5f1', collection.next
    assert_equal 'e45ab680-5bb1-11e9-8001-a0dcc2d8d5f1', collection.marker
  end

  it 'finds the data in the "records" field' do
    collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:marker_collection)
    assert_equal 4, collection.size
  end

  it 'recognizes "marker" markers' do
    collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:marker_collection)

    assert_equal nil, collection.count
    assert_equal 123_456, collection.next
    assert_equal 123_456, collection.marker
  end

  describe 'more_pages?' do
    it 'returns false if no more pages' do
      collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:marker_collection_no_more)

      assert_equal false, collection.more_pages?
    end

    it 'returns true if more pages available' do
      collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:marker_collection)

      assert_equal true, collection.more_pages?
    end
  end

  describe 'next_page' do
    it 'returns empty collection if no more pages' do
      collection = KlaviyoAPI::Collections::MarkerCollection.new JSON.parse load_fixture(:marker_collection_no_more)
      collection2 = collection.next_page

      assert_equal 0, collection2.size
    end

    it 'gets the next page of results' do
      stub_request(:get, 'https://a.klaviyo.com/api/v2/list/l1234/exclusions/all')
        .to_return body: load_fixture(:list_exclusions_with_marker)

      stub_request(:get, 'https://a.klaviyo.com/api/v2/list/l1234/exclusions/all?marker=marker123')
        .to_return body: load_fixture(:list_exclusions)

      collection = KlaviyoAPI::ListExclusion.all params: { list_id: 'l1234' }
      collection.next_page

      assert_requested :get, 'https://a.klaviyo.com/api/v2/list/l1234/exclusions/all?marker=marker123'
    end
  end
end
