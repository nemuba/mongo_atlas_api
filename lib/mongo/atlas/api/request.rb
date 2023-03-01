# frozen_string_literal: true

# This class is used to make requests to the cluster mongo-atlas
module Mongo
  module Atlas
    module Api
      # This class is used to make requests to the cluster mongo-atlas
      class Request < ServiceClient::Base
        # This method is used to find one document
        # Example: Mongo::Atlas::Api::Request.find_one(projection: { _id: 0 })
        #
        # @param [Hash] filter
        # @param [Hash] projection
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.find_one(filter: {}, projection: {})
          data = body.merge(projection:, filter:)
          response = post('action/findOne', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to find many documents
        # Example: Mongo::Atlas::Api::Request.find(limit: 20, filter: { name: 'John' }, sort: { name: 1 }, projection: { _id: 0 }, skip: 0)#
        #
        # @param [Integer] limit
        # @param [Hash] filter
        # @param [Hash] sort
        # @param [Hash] projection
        # @param [Integer] skip
        # @return [Array|ServiceClient::Response] the documents array or the response
        def self.find(limit: 20, filter: {}, sort: {}, projection: {}, skip: 0)
          data = body.merge(limit:, filter:, sort:, skip:, projection:)
          response = post('action/find', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to insert one document
        # Example: Mongo::Atlas::Api::Request.insert_one({ name: 'John', email: 'user@teste.com' })
        #
        # @param [Hash] document
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.insert_one(document, url: 'action/insertOne')
          data = url.eql?('action/insertOne') ? body.merge(document:) : body.merge(documents: document)

          response = post(url, body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to insert many documents
        # Example: Mongo::Atlas::Api::Request.insert_many([{ name: 'John', email: 'user@teste.com' }, ...])
        #
        # @param [Array] documents
        # @return [Array|ServiceClient::Response] the documents array or the response
        def self.insert_many(documents)
          documents.each_slice(1000).map do |documents_slice|
            insert_one(documents_slice, url: 'action/insertMany')
          end
        end

        # This method is used to update one document
        # Example: Mongo::Atlas::Api::Request.update_one(filter: { name: 'John' }, update: { $set: { name: 'John Doe' } })
        # @param [Hash] filter
        # @param [Hash] update
        # @param [Boolean] upsert
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.update_one(filter: {}, update: {}, upsert: false)
          data = body.merge(filter:, update:, upsert:)
          response = post('action/updateOne', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to update many documents
        # Example: Mongo::Atlas::Api::Request.update_many(filter: { name: 'John' }, update: { $set: { name: 'John Doe' } })
        #
        # @param [Hash] filter
        # @param [Hash] update
        # @param [Boolean] upsert
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.update_many(filter: {}, update: {}, upsert: false)
          data = body.merge(filter:, update:, upsert:)
          response = post('action/updateMany', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to replace one document
        # Example: Mongo::Atlas::Api::Request.replace_one(filter: { name: 'John' }, replacement: { name: 'John Doe' })
        #
        # @param [Hash] filter
        # @param [Hash] replacement
        # @param [Boolean] upsert
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.replace_one(filter: {}, replacement: {}, upsert: false)
          data = body.merge(filter:, replacement:, upsert:)
          response = post('action/replaceOne', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to delete one document
        # Example: Mongo::Atlas::Api::Request.delete_one(filter: { name: 'John' })
        #
        # @param [Hash] filter
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.delete_one(filter: {})
          data = body.merge(filter:)
          response = post('action/deleteOne', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        # This method is used to delete many documents
        # Example: Mongo::Atlas::Api::Request.delete_many(filter: { name: 'John' })
        #
        # @param [Hash] filter
        # @return [Hash|ServiceClient::Response] the document hash or the response
        def self.delete_many(filter: {})
          data = body.merge(filter:)
          response = post('action/deleteMany', body: data.to_json)

          response.data
        rescue StandardError => e
          e.response
        end

        class << self
          private

          def parse_response(&block)
            data = block.call

            case data
            when ServiceClient::Response
              { code: data.code, error: data.data }
            when Hash
              data['documents'] || data
            end
          end
        end
      end
    end
  end
end
