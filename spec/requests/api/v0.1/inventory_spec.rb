require "rails_helper"

RSpec.describe("v0.0.2 - Inventory") do
  describe("/topological_inventory/ingress_api/0.0.2/inventory") do
    context "post" do
      it "will filter the data from the logs" do
        headers = {"Content-Type" => "application/json"}
        body = JSON.dump(
          "name"        => "test",
          "schema"      => {"name" => "Default"},
          "source"      => "5408a3a0-e72c-49a0-ab92-bb3084db561d",
          "collections" => [
            {"name" => "container_images",     "data" => "HUMONGOUS_PAYLOAD"},
            {"name" => "container_image_tags", "data" => "HUMONGOUS_PAYLOAD"}
          ]
        )

        log_line = nil

        allow(Rails.logger).to receive(:info).and_call_original
        expect(Rails.logger).to receive(:info).with(/Parameters: /).once.and_wrap_original do |original, arg|
          log_line = arg
          original.call(arg)
        end

        post("/topological_inventory/ingress_api/0.0.2/inventory", :params => body, :headers => headers)

        expect(log_line).to     include("[FILTERED]")
        expect(log_line).to_not include("HUMONGOUS_PAYLOAD")
      end
    end
  end
end
