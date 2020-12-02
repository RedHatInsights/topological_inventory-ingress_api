Rails.application.routes.draw do
  # Disable PUT for now since rails sends these :update and they aren't really the same thing.
  def put(*_args); end

  routing_helper = Insights::API::Common::Routing.new(self)
  prefix         = "ingress_api"
  # if ENV["PATH_PREFIX"].present? && ENV["APP_NAME"].present?
  #   prefix = File.join(ENV["PATH_PREFIX"], ENV["APP_NAME"]).gsub(/^\/+|\/+$/, "")
  # end

  get "/health", :to => "status#health"

  namespace :topological_inventory do
    scope :as => :ingress_api, :module => "ingress_api", :path => prefix do
      namespace :v0x0x2, :path => "0.0.2" do
        get "/openapi.json", :to => "root#openapi"
        post "/inventory" => "inventory#save_inventory"
      end
    end
  end
end
