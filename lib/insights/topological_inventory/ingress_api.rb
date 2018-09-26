require "swaggering"

module Insights
  module TopologicalInventory
    class IngressApi < Swaggering
      require "insights/topological_inventory/ingress_api/admins"
      require "insights/topological_inventory/ingress_api/developers"

      self.configure do |config|
        config.api_version = "0.0.1"
      end
    end
  end
end
