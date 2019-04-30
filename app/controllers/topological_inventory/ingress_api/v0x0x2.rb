module TopologicalInventory
  module IngressApi
    module V0x0x2
      class RootController < ApplicationController
        def openapi
          render :json => Api::Docs["0.0.2"].content.to_json
        end
      end
      class InventoryController < IngressApi::V0::InventoryController; end
    end
  end
end
