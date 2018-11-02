module TopologicalInventory
  module IngressApi
    module V0
      class SchemasController < ApplicationController
        def index
          render json: ["Default"]
        end
      end
    end
  end
end
