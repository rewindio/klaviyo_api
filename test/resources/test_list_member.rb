# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::ListMember do
  LIST_ID = 'M2q6kN'
  BASE_LIST_MEMBERS_URL = "https://a.klaviyo.com/api/v2/list/#{LIST_ID}/members"

  it 'instantiates proper class' do
    stub_request(:get, BASE_LIST_MEMBERS_URL + '?emails=someone1@rewind.io')
      .to_return status: 200, body: load_fixture(:list_member)

    member = KlaviyoAPI::ListMember.first params: { list_id: LIST_ID, emails: 'someone1@rewind.io' }

    assert_instance_of KlaviyoAPI::ListMember, member
  end

  describe 'create' do
    before do
      stub_request(:post, BASE_LIST_MEMBERS_URL)
        .to_return status: 200, body: load_fixture(:list_member)
    end

    it 'assigns ID to self' do
      list_member = KlaviyoAPI::ListMember.create list_id: LIST_ID, email: 'someone@rewind.io'

      assert_equal 'NTNqNW', list_member.id
    end

    it 'calls POST with email wrapped in "profiles" array' do
      KlaviyoAPI::ListMember.create list_id: LIST_ID, email: 'someone@rewind.io'

      assert_requested :post, BASE_LIST_MEMBERS_URL, body: '{"profiles":[{"email":"someone@rewind.io"}]}'
    end
  end

  describe 'bulk_create' do
    it 'calls POST with email wrapped in "profiles" array' do
      stub_request(:post, BASE_LIST_MEMBERS_URL)
        .to_return status: 200, body: load_fixture(:list_members)

      KlaviyoAPI::ListMember.bulk_create(
        [
          KlaviyoAPI::ListMember.new(email: 'someone1@rewind.io'),
          KlaviyoAPI::ListMember.new(email: 'someone2@rewind.io')
        ],
        list_id: LIST_ID
      )

      assert_requested :post, BASE_LIST_MEMBERS_URL, body: '{"profiles":[{"email":"someone1@rewind.io"},{"email":"someone2@rewind.io"}]}'
    end
  end

  describe 'update' do
    it 'raises InvalidOperation' do
      stub_request(:post, BASE_LIST_MEMBERS_URL)
        .to_return status: 200, body: load_fixture(:list_member)

      list_member = KlaviyoAPI::ListMember.create list_id: LIST_ID, email: 'someone@rewind.io'

      error = assert_raises KlaviyoAPI::InvalidOperation do
        list_member.save
      end

      assert_match 'Cannot update list members. You might be looking for delete and/or create.', error.message
    end
  end

  describe 'delete' do
    it 'calls DELETE /list/:list_id/members with email in the URL' do
      stub_request(:delete, BASE_LIST_MEMBERS_URL + '?emails=someone1@rewind.io')
        .to_return status: 200

      KlaviyoAPI::ListMember.delete 'someone1@rewind.io', list_id: LIST_ID

      assert_requested :delete, BASE_LIST_MEMBERS_URL + '?emails=someone1@rewind.io'
    end
  end

  describe 'destroy' do
    it 'calls DELETE /list/:list_id/members with email in the URL' do
      stub_request(:delete, BASE_LIST_MEMBERS_URL + '?emails=someone1@rewind.io')
        .to_return status: 200

      list_member = KlaviyoAPI::ListMember.new id: '123', email: 'someone1@rewind.io', list_id: LIST_ID
      list_member.destroy

      assert_requested :delete, BASE_LIST_MEMBERS_URL + '?emails=someone1@rewind.io'
    end
  end
end
