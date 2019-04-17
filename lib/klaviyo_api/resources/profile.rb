# frozen_string_literal: true

module KlaviyoAPI
  class Profile < Base
    extend KlaviyoAPI::Support::Countable

    self.prefix += 'v1/'

    self.element_name = 'person'
    self.collection_parser = KlaviyoAPI::Collections::Profile

    class << self
      def collection_path(prefix_options = {}, query_options = {})
        super prefix_options, query_options.deep_merge({ api_key: headers['api-key'] })
      end

      def element_path(id, prefix_options = {}, query_options = {})
        super id, prefix_options, query_options.deep_merge({ api_key: headers['api-key'] })
      end
    end

    def destroy
      raise KlaviyoAPI::InvalidOperation.new 'Cannot delete Profiles via API.'
    end

    def create
      raise KlaviyoAPI::InvalidOperation.new 'Cannot create Profiles via API.'
    end

    def update
      run_callbacks :update do
        # This endpoint does not accept JSON bodies. Additionally, if the API key is in the URL, the rest of the attributes
        # MUST be in the URL as well. The other option is to have the API key and all attributes in the body as `key=value` pairs.
        #
        # To reduce friction, as we already need the API key in the URL for other operations, let's just add all the attributes
        # to the URL. Unfortunately we will need to include ALL the attributes, not just the changed ones, because it seems
        # ActiveResource has no support for dirty models. https://github.com/rails/activeresource/issues/308
        path = self.class.element_path(id, prefix_options, attributes)

        connection.put(path, nil, self.class.headers).tap do |response|
          load_attributes_from_response(response)
        end
      end
    end

    private

    def method_missing(method_symbol, *arguments)
      method_name = method_symbol.to_s

      # Some fields start with a $ (e.g., '$title'). The methods `title`, `title?`
      # and `title=` should act upon the attribute `$title` if present. Otherwise,
      # they should act upon the attribute `title`
      #
      # Not a whole lot we can do if the item contains both `title` and `$title` -
      # this will prioritize the version with the $.
      if attributes.keys.any? { |attribute| attribute == "$#{method_name.sub(/\?|=$/, '')}" }
        method_symbol = "$#{method_name}".to_sym
      end

      super
    end
  end
end
