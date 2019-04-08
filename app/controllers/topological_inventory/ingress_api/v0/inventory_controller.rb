module TopologicalInventory
  module IngressApi
    module V0
      class InventoryController < ApplicationController
        skip_before_action :verify_authenticity_token
        def save_inventory
          messaging_client.publish_message(
            :service => "platform.topological-inventory.persister",
            :message => "save_inventory",
            :payload => JSON.parse(request.body.read),
          )

          render status: 200, :json => {
            :message => "ok",
          }.to_json
        rescue Kafka::MessageSizeTooLarge => e
          render :status => 500, :json => {
            :message    => e.message,
            :error_code => e.class.to_s,
          }.to_json
        rescue => e
          render :status => 500, :json => {
            :message    => e.message,
            :error_code => e.class.to_s,
          }.to_json

          raise e
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
