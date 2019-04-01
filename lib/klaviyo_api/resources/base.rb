# frozen_string_literal: true

module KlaviyoAPI
  class Base < ActiveResource::Base
    headers['User-Agent'] = "KlaviyoAPI/#{KlaviyoAPI::VERSION}"
    headers['Accept'] = 'application/json'

    self.site = KlaviyoAPI.configuration.url

    self.include_format_in_path = false

    self.format = KlaviyoAPI::JsonFormatter.new :result

    class << self
      def activate_session(session)
        self.headers['api-key'] = session.api_key.to_s # rubocop:disable Style/RedundantSelf

        KlaviyoAPI::Base.site = KlaviyoAPI.configuration.url
      end

      def reset_session
        self.headers['api-key'] = nil # rubocop:disable Style/RedundantSelf

        KlaviyoAPI::Base.site = KlaviyoAPI.configuration.url
      end

      def headers
        return _headers            if _headers_defined?
        return superclass.headers  if superclass != Object && superclass.headers

        _headers || {}
      end

      def exists?(id, options = {})
        true if find id, options.deep_merge(params: { fields: primary_key })
      rescue ActiveResource::ResourceNotFound
        false
      end
    end

    def to_h
      JSON.parse(attributes.to_json).symbolize_keys
    end

    # def find(*arguments)
    #   arguments[1] = arguments[1] || { params: {} }
    #   super *arguments
    # end

    # def update
    #   # this is going to generate the path with the :id in it
    #   path = element_path prefix_options

    #   # v2 endpoints don't allow the :id in the params
    #   # id = attributes.delete :id

    #   run_callbacks :update do
    #     connection.put(path, encode, self.class.headers).tap do |response|
    #       self.id = id_from_response response

    #       load_attributes_from_response response
    #     end
    #   end
    # rescue
    #   self.id = id

    #   raise
    # end
  end
end
