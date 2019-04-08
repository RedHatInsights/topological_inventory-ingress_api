module TopologicalInventory
  module IngressApi
    def self.with_messaging_client
      messaging_client ||= raw_messaging_client
      raise if messaging_client.nil?

      begin
        yield messaging_client
      rescue Kafka::ConnectionError
        messaging_client.close
        self.messaging_client = nil

        raise
      end
    end

    private_class_method def self.messaging_client
      Thread.current[:messaging_client]
    end

    private_class_method def self.messaging_client=(value)
      Thread.current[:messaging_client] = value
    end

    private_class_method def self.raw_messaging_client
      ManageIQ::Messaging::Client.open(
        :encoding => "json",
        :host     => ENV["QUEUE_HOST"] || "localhost",
        :port     => ENV["QUEUE_PORT"] || "9092",
        :protocol => :Kafka,
      )
    end
  end
end