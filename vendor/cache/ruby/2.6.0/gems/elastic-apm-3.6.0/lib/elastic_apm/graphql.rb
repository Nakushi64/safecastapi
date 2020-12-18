# frozen_string_literal: true

module ElasticAPM
  # @api private
  module GraphQL
    TYPE = 'app'
    SUBTYPE = 'graphql'

    PREFIX = 'GraphQL: '
    UNNAMED = '[unnamed]'
    MULTIPLE_QUERIES = '[multiple-queries]'
    CONCATENATOR = '+'
    MAX_NUMBER_OF_QUERIES_FOR_NAME = 5

    KEYS_TO_NAME = {
      'lex' => 'graphql.lex',
      'parse' => 'graphql.parse',
      'validate' => 'graphql.validate',
      'analyze_multiplex' => 'graphql.analyze_multiplex',
      'analyze_query' => 'graphql.analyze_query',
      'execute_multiplex' => 'graphql.execute_multiplex',
      'execute_query' => 'graphql.execute_query',
      'execute_query_lazy' => 'graphql.execute_query_lazy',
      'authorized_lazy' => 'graphql.authorized_lazy',
      'resolve_type' => 'graphql.resolve_type',
      'resolve_type_lazy' => 'graphql.resolve_type_lazy'

      # These are available but deliberately left out as they are mostly noise.
      # "execute_field" => "graphql.execute_field",
      # "execute_field_lazy" => "graphql.execute_field_lazy",
      # "authorized" => "graphql.authorized",
    }.freeze

    def self.trace(key, data)
      return yield unless KEYS_TO_NAME.key?(key)
      return yield unless (transaction = ElasticAPM.current_transaction)

      if key == 'execute_query'
        transaction.name =
          "#{PREFIX}#{query_name(data[:query])}"
      end

      results =
        ElasticAPM.with_span(
          KEYS_TO_NAME.fetch(key, key),
          TYPE, subtype: SUBTYPE, action: key
        ) { yield }

      if key == 'execute_multiplex'
        transaction.name = "#{PREFIX}#{concat_names(results)}"
      end

      results
    end

    class << self
      private

      def query_name(query)
        query.operation_name || UNNAMED
      end

      def concat_names(results)
        if results.length > MAX_NUMBER_OF_QUERIES_FOR_NAME
          return MULTIPLE_QUERIES
        end

        results.map do |result|
          query_name(result.query)
        end.join(CONCATENATOR)
      end
    end
  end
end
