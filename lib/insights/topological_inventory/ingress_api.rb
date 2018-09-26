require "swaggering"
require "manageiq-messaging"

module Insights
  module TopologicalInventory
    class IngressApi < Swaggering
      require "insights/topological_inventory/ingress_api/admins"
      require "insights/topological_inventory/ingress_api/developers"

      self.configure do |config|
        config.api_version = "0.0.1"
      end

      private

      def messaging_client
        @messaging_client ||= ManageIQ::Messaging::Client.open(messaging_opts)
      end

      def messaging_opts
        {
          :protocol => :Kafka,
          :host     => "localhost",
          :port     => "9092",
        }
      end
    end
  end
end
