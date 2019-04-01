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

      def element_path(id, prefix_options = {}, query_options = nil)
        check_prefix_options(prefix_options)

        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{element_name}/#{URI.parser.escape id.to_s}#{format_extension}#{query_string(query_options)}"
      end
    end

    def to_h
      JSON.parse(attributes.to_json).symbolize_keys
    end
  end
end