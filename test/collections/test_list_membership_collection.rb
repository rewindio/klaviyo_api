# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Collections::MarkerCollection do
  describe 'next_page' do
    it 'returns empty collection if no more pages' do
      collection = KlaviyoAPI::Collections::ListMembershipCollection.new JSON.parse load_fixture(:list_members_records_without_marker)
      collection2 = collection.next_page

      assert_equal 0, collection2.size
    end

    it 'gets the next page of results' do
      stub_request(:get, 'https://a.klaviyo.com/api/v2/group/l1234/members/all')
        .to_return body: load_fixture(:list_members_records_with_marker)

      stub_request(:get, 'https://a.klaviyo.com/api/v2/group/l1234/members/all?marker=12345')
        .to_return body: load_fixture(:list_members_records_without_marker)

      collection = KlaviyoAPI::ListMember.all_members params: { list_id: 'l1234' }
      collection.next_page

      assert_requested :get, 'https://a.klaviyo.com/api/v2/group/l1234/members/all?marker=12345'
    end
  end
end
