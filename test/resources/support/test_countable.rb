# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Support::Countable do
  before do
    stub_request(:get, "https://a.klaviyo.com/api/v1/people?api_key=&count=1")
      .to_return body: load_fixture(:people)
  end

  it 'successfully gets a count' do
    assert_equal 3, KlaviyoAPI::Profile.count
  end
end
