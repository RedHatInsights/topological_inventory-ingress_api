module TopologicalInventory
  module IngressApi
    module MessagingClient
      extend ActiveSupport::Concern

      included do
        private_class_method :messaging_client,
                             :new_messaging_client
      end

      module ClassMethods
        def with_messaging_client
          raise if messaging_client.nil?

          begin
            yield messaging_client
          rescue ::Rdkafka::RdkafkaError => e
            if (e.message =~ /(msg_size_too_large)/).present?
              # Don't reset the connection for user-error
              raise
            end

            # If we hit an underlying kafka error then reset the connection
            messaging_client.close
            self.messaging_client = nil

            raise
          end
        end

        def messaging_client
          @messaging_client ||= new_messaging_client
        end

        def new_messaging_client(retry_max = 1)
          retry_count = 0
          begin
            ManageIQ::Messaging::Client.open(
              :encoding => "json",
              :host     => ENV["QUEUE_HOST"] || "localhost",
              :port     => ENV["QUEUE_PORT"] || "9092",
              :protocol => :Kafka,
            )
          end
        rescue ::Rdkafka::RdkafkaError
          retry_count += 1
          retry unless retry_count > retry_max
        end
      end
    end
  end
end
