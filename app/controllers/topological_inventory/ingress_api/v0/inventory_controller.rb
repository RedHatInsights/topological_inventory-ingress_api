module TopologicalInventory
  module IngressApi
    module V0
      class InventoryController < ApplicationController
        skip_before_action :verify_authenticity_token
        def save_inventory
          messaging_client.publish_message(
            :service => "topological_inventory-persister",
            :message => "save_inventory",
            :payload => JSON.parse(request.body.read),
          )

          {"message" => "yes, it worked"}.to_json
        end

        private

        def messaging_client
          ManageIQ::Messaging::Client.open(messaging_opts)
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
  end
end
