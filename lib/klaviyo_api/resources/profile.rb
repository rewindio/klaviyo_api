# frozen_string_literal: true

module KlaviyoAPI
  class Profile < Base
    self.prefix += 'v1/'

    self.collection_name = 'people'
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
