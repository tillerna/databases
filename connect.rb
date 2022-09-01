require 'mysql2'

module MySqlServer
  module Database
    class Connect
      attr_reader :mysql_client, :table, :primary_column

      def initialize(table, primary_column)
        @table = table
        @primary_column = primary_column
      end

      def fetch_all
        perform_mysql_operation do
          result = mysql_client.query("SELECT * from #{table}")

          result.entries
        end
      end

      def fetch_one(id)
        perform_mysql_operation do
          result = mysql_client.query("SELECT * from #{table} WHERE #{primary_column}=#{id}")

          result.entries
        end
      end

      private

      def connect_to_db
        host = ENV['localhost']
        username = ENV['nate']
        password = ENV['DevPwd123*']
        database = ENV['sentry']

        Mysql2::Client.new(username: username, password: password, database: database, host: host)
      end

      def perform_mysql_operation
        raise ArgumentError, 'No block was given' unless block_given?

        begin
          @mysql_client = connect_to_db

          yield
        rescue StandardError => e
          raise e
        ensure
          mysql_client&.close
        end
      end
    end
  end
end

connect_to_db
puts mysql_client.query("SELECT * from res_moa")