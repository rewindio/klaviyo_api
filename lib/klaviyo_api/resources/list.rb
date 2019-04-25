# frozen_string_literal: true

module KlaviyoAPI
  class List < Base
    self.prefix += 'v2/'
    self.primary_key = :list_id

    has_many :exclusions, class_name: 'KlaviyoAPI::ListExclusion'

    class << self
      # Override this from ActiveResource#base in order to inject the id into the response
      # because its not returned
      def find_single(scope, options)
        super.tap { |record| record.id = scope }
      end
    end

    # Gets all Members of this List. Uses the Groups endpoint.
    # Returns an enumerator that knows how to transparently deal
    # with Klaviyo's `marker` for pagination. Pages seem to be
    # 1000 items.
    #
    # https://www.klaviyo.com/docs/api/v2/lists#get-members-all
    def members
      CachingEnumerator.new do |yielder|
        marker = nil

        loop do
          path = "#{self.class.prefix}group/#{id}/members/all"
          path += "?marker=#{marker}" if marker

          response = JSON.parse(connection.get(path, self.class.headers).body)
          marker = response['marker']
          list_members = response['records']

          list_members.each do |list_member|
            yielder.yield KlaviyoAPI::ListMember.new list_member
          end

          break if marker.nil?
        end
      end
    end
  end
end
