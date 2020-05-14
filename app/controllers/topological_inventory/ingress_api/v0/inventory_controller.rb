require "topological_inventory/ingress_api"
require "topological_inventory/ingress_api/docs"
require "topological_inventory/ingress_api/messaging_client"

module TopologicalInventory
  module IngressApi
    module V0
      class InventoryController < ::ApplicationController
        include TopologicalInventory::IngressApi::MessagingClient

        before_action :add_timestamp_to_payload, :only => %i[save_inventory]
        before_action :validate_request

        def add_timestamp_to_payload
          body_params['ingress_api_sent_at'] = Time.now.utc.to_s
        end

        def save_inventory
          retry_count  = 0
          retry_max    = 1

          self.class.with_messaging_client do |client|
            begin
              client.publish_message(save_inventory_payload(body_params.to_json))
            rescue Kafka::DeliveryFailed
              retry_count += 1
              retry unless retry_count > retry_max
            end
          end

          metrics.message_on_queue
          render status: 200, :json => {
            :message => "ok",
          }.to_json
        rescue => e
          metrics.error_processing_payload
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

        def metrics
          Insights::API::Common::Metrics
        end
      end
    end
  end
end
