# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::List do
  BASE_LIST_URL = 'https://a.klaviyo.com/api/v2'
  LIST_ID = 'M2q6kN'

  before do
    stub_request(:get, BASE_LIST_URL + '/lists')
      .to_return body: load_fixture(:lists)

    stub_request(:get, BASE_LIST_URL + "/list/#{LIST_ID}")
      .to_return body: load_fixture(:list)
  end

  it 'instantiates proper class' do
    lists = KlaviyoAPI::List.all

    assert_kind_of ActiveResource::Collection, lists
    assert_instance_of KlaviyoAPI::List, lists.first
  end

  it 'uses the proper collection path' do
    assert_equal KlaviyoAPI::List.collection_path, '/api/v2/lists'
  end

  it 'uses the proper element path' do
    assert_equal KlaviyoAPI::List.element_path('abc123'), '/api/v2/list/abc123'
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
      stub_request(:put, BASE_LIST_URL + "/list/#{LIST_ID}")
        .to_return status: 200

      list = KlaviyoAPI::List.find LIST_ID
      list.list_name = 'something else'
      list.save

      assert_requested :put, BASE_LIST_URL + "/list/#{LIST_ID}"
    end
  end

  describe 'create' do
    it 'calls POST /lists' do
      stub_request(:post, BASE_LIST_URL + '/lists')
        .to_return status: 200

      list = KlaviyoAPI::List.new
      list.list_name = 'new list'

      list.save

      assert_requested :post, BASE_LIST_URL + '/lists'
    end
  end

  describe 'delete' do
    it 'calls DELETE /list/:list_id' do
      stub_request(:delete, BASE_LIST_URL + "/list/#{LIST_ID}")
        .to_return status: 200

      list = KlaviyoAPI::List.find LIST_ID

      list.destroy

      assert_requested :delete, BASE_LIST_URL + "/list/#{LIST_ID}"
    end
  end
end
