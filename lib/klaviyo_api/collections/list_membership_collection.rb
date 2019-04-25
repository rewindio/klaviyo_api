# frozen_string_literal: true

module KlaviyoAPI::Collections
  # ListMembershipCollection, as opposed to ListMemberCollection.
  # This is a collection of ListMembers, but _specifically_ in the
  # context of the Group Memberships endpoint of a List.
  # (https://www.klaviyo.com/docs/api/v2/lists#get-members-all)
  class ListMembershipCollection < MarkerCollection
    def next_page
      # Return empty collection if no other pages
      return self.class.new unless more_pages?

      KlaviyoAPI::ListMember.all_members params: { **first.prefix_options, **original_params, "#{next_page_marker_name}": marker }
    end
  end
end
