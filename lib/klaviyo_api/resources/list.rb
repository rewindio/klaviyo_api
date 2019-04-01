# frozen_string_literal: true

module KlaviyoAPI
  class List < Base
    # self.collection_parser = CollectionParsers::List
    self.prefix += 'v2/'
    self.primary_key = :list_id

    # def list_id
    #   prefix_options['list_id'] || prefix_options[:list_id]
    # end
  end
end
