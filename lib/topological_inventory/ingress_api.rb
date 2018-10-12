require "swaggering"
require "manageiq-messaging"

module TopologicalInventory
  class IngressApi < Swaggering
    require "topological_inventory/ingress_api/admins"
    require "topological_inventory/ingress_api/developers"

    self.configure do |config|
      config.api_version = "0.0.2"
    end

    private

    def messaging_client
      @messaging_client ||= ManageIQ::Messaging::Client.open(messaging_opts)
    end

    def messaging_opts
      {
        :protocol => :Kafka,
        :host     => ENV["QUEUE_HOST"] || "localhost",
        :port     => ENV["QUEUE_PORT"] || "9092",
        :encoding => "json",
      }
    end
  end
end
