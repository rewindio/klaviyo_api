# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Support::Enumerable do
  it 'yields all values' do
    stub_request(:get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=10&offset=0')
      .to_return body: load_fixture(:merge_fields)

    stub_request(:get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=0&fields=total_items')
      .to_return body: '{"total_items": 5}'

    yield_count = 0
    KlaviyoAPI::MergeField.enumerator(params: { list_id: 'list1234' }).each { yield_count += 1 }

    assert_equal 5, yield_count
  end

  it 'respects pagination' do
    stub_request(:get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=0')
      .to_return body: load_fixture(:merge_fields)
    stub_request(:get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=2')
      .to_return body: load_fixture(:merge_fields)
    stub_request(:get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=4')
      .to_return body: load_fixture(:merge_fields)

    stub_request(:get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=0&fields=total_items')
      .to_return body: '{"total_items": 6}'

    KlaviyoAPI::MergeField.enumerator(page_size: 2, params: { list_id: 'list1234' }).each {}

    assert_requested :get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=0', times: 1
    assert_requested :get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=2', times: 1
    assert_requested :get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=4', times: 1
    assert_not_requested :get, 'https://a.klaviyo.com/api/v2/lists/list1234/merge-fields?count=2&offset=6'
  end
end
