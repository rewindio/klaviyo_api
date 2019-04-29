# frozen_string_literal: true

module KlaviyoAPI
  class ListMember < Base
    ORIGINAL_PREFIX = '/api/v2/list/:list_id/'
    self.prefix = ORIGINAL_PREFIX

    self.primary_key = :id

    # This is always plural
    self.element_name = 'members'

    class << self
      # Removing a Member from a List is a DELETE call, but no ID is given.
      # Instead, the email must be provided in the query params.
      # Klaviyo also accepts an array in the body, but Ruby's HTTP library
      # does not support DELETE bodies (as per the HTTP spec).
      #
      # https://www.klaviyo.com/docs/api/v2/lists#delete-members
      def delete(email, options = {})
        options = options.merge emails: email
        connection.delete(element_path('', options), headers)
      end

      # A shortcut to create multiple ListMembers at once, as supported
      # by the Klaviyo API.
      #
      # https://www.klaviyo.com/docs/api/v2/lists#post-members
      def bulk_create(list_members, options = {})
        payload = { profiles: list_members }.to_json

        saved_list_members = []
        connection.post(collection_path(options), payload, headers).tap do |response|
          list_members_json = JSON.parse(response.body)
          list_members_json.each do |list_member_json|
            saved_list_members << KlaviyoAPI::ListMember.new(list_member_json)
          end
        end
        saved_list_members
      end

      # As opposed to #all, which hits and requires a list of emails to check for membership,
      # this method hits https://www.klaviyo.com/docs/api/v2/lists#get-members-all and gets all
      # ListMembers for a List.
      def all_members(options)
        # The rest becomes much easier if we temporarily modify the prefix.
        # We set it back later, have no fear.
        self.prefix = '/api/v2/group/:list_id/members/all'

        prefix_options, query_options = split_options(options[:params])
        path = "#{prefix(prefix_options)}#{format_extension}#{query_string(query_options)}"

        # Very heavily inspired by `find_every`
        response = format.decode(connection.get(path, headers).body) || []
        collection = KlaviyoAPI::Collections::ListMembershipCollection.new(response).tap do |parser|
          parser.resource_class  = self
          parser.original_params = query_options
        end

        collection.collect! { |record| instantiate_record(record, prefix_options) }

        self.prefix = ORIGINAL_PREFIX

        collection
      end
    end

    # Adding a single Member to a List does not exist - they must be added as an
    # array of Profiles. In order to fit AR, we need to wrap self in an array,
    # and remove it in the response.
    #
    # https://www.klaviyo.com/docs/api/v2/lists#post-members
    def create
      payload = { profiles: [self] }.to_json

      run_callbacks :create do
        connection.post(collection_path, payload, self.class.headers).tap do |response|
          response.body = JSON.parse(response.body)[0].to_json
          self.id = id_from_response(response)
          load_attributes_from_response(response)
        end
      end
    end

    # Can only delete by email, not ID.
    #
    # https://www.klaviyo.com/docs/api/v2/lists#delete-members
    def destroy
      run_callbacks :destroy do
        KlaviyoAPI::ListMember.delete email, prefix_options
      end
    end

    def update
      raise KlaviyoAPI::InvalidOperation, 'Cannot update list members. You might be looking for delete and/or create.'
    end
  end
end
