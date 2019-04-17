# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::Profile do
  before do
    stub_request(:get, %r{#{BASE_PROFILE_URL}\/people})
      .to_return body: load_fixture(:people)
  end

  it 'finds the Profiles in the raw response' do
    collection = KlaviyoAPI::Profile.all
    assert_equal 3, collection.size
  end

  it 'sets all pagination attributes' do
    collection = KlaviyoAPI::Profile.all

    assert_equal 3, collection.total
    assert_equal 0, collection.page
    assert_equal 1000, collection.page_size
    assert_equal 0, collection.start
    assert_equal 2, collection.end
  end
end
