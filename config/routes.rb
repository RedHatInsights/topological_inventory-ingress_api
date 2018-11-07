Rails.application.routes.draw do
  namespace :topological_inventory do
    namespace :ingress_api do
      namespace :v0x0x2, :path => "0.0.2" do
        resources :schemas, :only => [:index]
        post "/inventory" => "inventory#save_inventory"
      end
    end
  end
end
