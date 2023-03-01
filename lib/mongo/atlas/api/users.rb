# frozen_string_literal: true

module Mongo
  module Atlas
    module Api
      class Users < Request
        base_url ENV['CLUSTER_URL']
        default_headers 'Content-Type': 'application/json',
                        'api-key': ENV['CLUSTER_API_KEY'],
                        'Access-Control-Request-Headers': '*'

        def self.all(limit: 100, sort: { _id: 1 })
          parse_response { find(limit:, sort:) }
        end

        def self.select(filter, limit: 100, sort: { _id: 1 })
          parse_response { find(filter:, limit:, sort:) }
        end

        def self.insert(document)
          parse_response { insert_one(document) }
        end

        def self.insert_all(documents)
          parse_response { insert_many(documents) }
        end

        def self.destroy(where: {})
          parse_response { delete_one(filter: where) }
        end

        def self.destroy_all(where: {})
          parse_response { delete_many(filter: where) }
        end

        def self.update(where: {}, set: {})
          parse_response { update_one(filter: where, update: { '$set': set }) }
        end

        def self.update_all(where: {}, set: {})
          parse_response { update_many(filter: where, update: { '$set': set }) }
        end

        def self.size
          parse_response { count }
        end

        class << self
          private

          def body
            {
              collection: 'users',
              database: 'app_name',
              dataSource: 'ojeda'
            }
          end
        end
      end
    end
  end
end
