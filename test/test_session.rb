# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Session do
  let(:api_key) { 'pk_xxxyyyzzz' }

  it 'successfully_initialize' do
    session = KlaviyoAPI::Session.new api_key

    assert_equal api_key, session.api_key
  end

  it 'temp_cleanup' do
    assert_nil KlaviyoAPI::Base.headers['api-key']
    assert_equal KlaviyoAPI::Base.site.to_s, KlaviyoAPI.configuration.url

    KlaviyoAPI::Session.temp(api_key) do
      assert_equal KlaviyoAPI::Base.headers['api-key'], "#{api_key}"
    end

    assert_nil KlaviyoAPI::Base.headers['api-key']
    assert_equal KlaviyoAPI::Base.site.to_s, KlaviyoAPI.configuration.url
  end
end
