require "topological_inventory/ingress_api"
require "topological_inventory/ingress_api/docs"
require "topological_inventory/ingress_api/messaging_client"

module TopologicalInventory
  module IngressApi
    module V0
      class InventoryController < ::ApplicationController
        include TopologicalInventory::IngressApi::MessagingClient

        def save_inventory
          json_payload = request.body.read
          payload      = JSON.parse(json_payload)
          dup_payload  = payload.deep_dup

          retry_count = 0
          retry_max   = 1

          self.class.with_messaging_client do |client|
            begin
              # TODO(lsmola) can use this after https://github.com/ManageIQ/manageiq-messaging/pull/45 is released
              # client.publish_message(save_inventory_payload(json_payload))
              client.publish_message(save_inventory_payload(dup_payload))
            rescue Kafka::DeliveryFailed
              retry_count += 1
              retry unless retry_count > retry_max
            end
          end

          render status: 200, :json => {
            :message => "ok",
          }.to_json
        rescue => e
          render :status => 500, :json => {
            :message    => e.message,
            :error_code => e.class.to_s,
          }.to_json

          raise e
        end

        private

        def save_inventory_payload(raw_payload)
          {
            :service  => "platform.topological-inventory.persister",
            :message  => "save_inventory",
            :encoding => 'json',
            :payload  => raw_payload,
          }
        end
      end
    end
  end
end
