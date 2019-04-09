# frozen_string_literal: true

module KlaviyoAPI
  class ListMember < Base
    self.prefix += 'v2/list/:list_id/'
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
      def delete(id, options = {})
        options = options.merge({emails: id})
        connection.delete(element_path('', options), headers)
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
        KlaviyoAPI::Member.delete self.email, prefix_options
      end
    end

    def update
      raise KlaviyoAPI::InvalidOperation.new 'Cannot update list members. You might be looking for delete and/or create.'
    end
  end
end
