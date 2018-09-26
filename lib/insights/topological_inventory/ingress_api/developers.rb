require "json"

module Insights
  module TopologicalInventory
    IngressApi.add_route("GET", "/insights/topological_inventory/ingress_api/0.0.1/schemas", {
      "resourcePath" => "/Developers",
      "summary" => "searches schemas",
      "nickname" => "search_schemas", 
      "responseClass" => "array[Schema]", 
      "endpoint" => "/schemas", 
      "notes" => "By passing in the appropriate options, you can search for available inventory schemas in the system ",
      "parameters" => [
        {
          "name" => "search_string",
          "description" => "pass an optional search string for looking up schemas",
          "dataType" => "string",
          "paramType" => "query",
          
          "allowableValues" => "",
          
        },
        {
          "name" => "skip",
          "description" => "number of records to skip for pagination",
          "dataType" => "int",
          "paramType" => "query",
          
          "allowableValues" => "",
          
        },
        {
          "name" => "limit",
          "description" => "maximum number of records to return",
          "dataType" => "int",
          "paramType" => "query",
          
          "allowableValues" => "",
          
        },
        ]}) do
      cross_origin
      # the guts live here

      {"message" => "yes, it worked"}.to_json
    end
  end
end
