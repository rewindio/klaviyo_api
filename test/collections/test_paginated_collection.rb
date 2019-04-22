# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::PaginatedCollection do
  it 'finds the data in the raw response' do
    collection = KlaviyoAPI::Collections::PaginatedCollection.new JSON.parse(load_fixture :paginated_collection)
    assert_equal 1, collection.size
  end

  it 'sets all pagination attributes' do
    collection = KlaviyoAPI::Collections::PaginatedCollection.new JSON.parse(load_fixture :paginated_collection)

    assert_equal 567, collection.total
    assert_equal 0, collection.page
    assert_equal 12, collection.page_size
    assert_equal 0, collection.start
    assert_equal 11, collection.end
  end
end
