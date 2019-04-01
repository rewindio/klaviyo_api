# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Session do
  let(:api_key) { 'xxxyyyzzz-us7' }

  it 'successfully_initialize' do
    session = KlaviyoAPI::Session.new api_key

    assert_equal api_key, session.api_key
    assert_equal 'us7', session.api_region_identifier
  end

  it 'temp_cleanup' do
    assert_equal KlaviyoAPI::Base.headers['Authorization'], 'OAuth '
    assert_equal KlaviyoAPI::Base.site.to_s, KlaviyoAPI.configuration.url

    KlaviyoAPI::Session.temp(api_key) do
      assert_equal KlaviyoAPI::Base.headers['Authorization'], "OAuth #{api_key}"
    end

    assert_equal KlaviyoAPI::Base.headers['Authorization'], 'OAuth '
    assert_equal KlaviyoAPI::Base.site.to_s, KlaviyoAPI.configuration.url
  end
end
