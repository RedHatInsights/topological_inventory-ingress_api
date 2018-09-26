lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "insights/topological_inventory/ingress_api"
run Insights::TopologicalInventory::IngressApi
