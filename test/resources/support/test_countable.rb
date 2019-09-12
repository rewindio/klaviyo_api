# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Support::Countable do
  it 'successfully gets a count' do
    stub_request(:get, 'https://a.klaviyo.com/api/v1/people?api_key=&count=1').to_return body: load_fixture(:paginated_collection)
    assert_equal 567, KlaviyoAPI::Profile.count
  end

  it 'returns zero when 400 error is returned from klaviyo' do
    stub_request(:get, 'https://a.klaviyo.com/api/v1/people?api_key=&count=1').to_return(status: 400, body: '')
    assert_equal 0, KlaviyoAPI::Profile.count
  end
end
