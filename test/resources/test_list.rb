# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::List do
  BASE_LIST_URL = 'https://a.klaviyo.com/api/v2/lists'
  LIST_ID = 'M2q6kN'

  before do
    stub_request(:get, BASE_LIST_URL)
      .to_return body: load_fixture(:lists)

    stub_request(:get, BASE_LIST_URL + "/#{LIST_ID}")
      .to_return body: load_fixture(:list)
  end

  it 'instantiates proper class' do
    lists = KlaviyoAPI::List.all

    assert_kind_of ActiveResource::Collection, lists
    assert_instance_of KlaviyoAPI::List, lists.first
  end

  describe 'GET /lists' do
    it 'fetches all lists' do
      lists = KlaviyoAPI::List.all

      assert_equal 3, lists.count
    end
  end

  describe 'GET /lists/:list_id' do
    it 'fetches specific list' do
      list = KlaviyoAPI::List.find LIST_ID

      assert_equal LIST_ID, list.id
      assert_empty list.prefix_options

      assert_respond_to list, :list_name
    end
  end

  describe 'update' do
    it 'calls PUT /lists/:list_id/' do
      stub_request(:put, BASE_LIST_URL + "/#{LIST_ID}")
        .to_return status: 200

      list = KlaviyoAPI::List.find LIST_ID
      list.list_name = 'something else'
      list.save

      assert_requested :put, BASE_LIST_URL + "/#{LIST_ID}"
    end
  end
end
