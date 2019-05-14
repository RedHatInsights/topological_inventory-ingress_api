require "rails_helper"

RSpec.describe("v0.0.2 - Inventory") do
  describe("/topological_inventory/ingress_api/0.0.2/inventory") do
    context "post" do
      it "will filter the data from the logs" do
        headers = {"Content-Type" => "application/json"}
        body    = JSON.dump(
          "name"        => "test",
          "schema"      => {"name" => "Default"},
          "source"      => "5408a3a0-e72c-49a0-ab92-bb3084db561d",
          "collections" => [
            {"name" => "container_images", "data" => "HUMONGOUS_PAYLOAD"},
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

        expect(log_line).to include("[FILTERED]")
        expect(log_line).to_not include("HUMONGOUS_PAYLOAD")
      end
    end

    context "validate post" do
      before do
        client = double
        allow(client).to receive(:publish_message)

        allow(TopologicalInventory::IngressApi).to receive(:with_messaging_client).and_yield(client)
      end

      let(:headers) do
        {"Content-Type" => "application/json"}
      end

      let(:container_group_body) do
        {
          "name"                    => "OCP",
          "schema"                  => {"name" => "Default"},
          "source"                  => "31b5338b-685d-4056-ba39-d00b4d7f19bd",
          "refresh_state_uuid"      => "a27bba9c-589d-46c4-a9cf-9c85043ccc62",
          "refresh_state_part_uuid" => "a310ca56-c409-40f6-969a-7dc5669b456c",
          "collections"             => [
            {
              "name" => "container_groups",
              "data" => [
                container_group_data
              ]
            }
          ]
        }
      end

      let(:container_group_data) do
        {
          "container_node"     => {"inventory_collection_name" => "container_nodes",
                                   "reference"                 => {"name" => "ip-172-31-54-244.ec2.internal"},
                                   "ref"                       => "by_name"},
          "container_project"  => {"inventory_collection_name" => "container_projects",
                                   "reference"                 => {"name" => "apicast-test"},
                                   "ref"                       => "by_name"},
          "ipaddress"          => "10.131.7.181",
          "name"               => "apicast-1-hwjns",
          "resource_timestamp" => "2019-05-10 13:57:38 UTC",
          "resource_version"   => "348457126",
          "source_created_at"  => "2019-04-10T15:35:45Z",
          "source_ref"         => "4ee2498b-5ba6-11e9-bf53-0a0ddbb52ad4",
        }
      end

      let(:container_node_body) do
        {
          "name"                    => "OCP",
          "schema"                  => {"name" => "Default"},
          "source"                  => "31b5338b-685d-4056-ba39-d00b4d7f19bd",
          "refresh_state_uuid"      => "a2116550-ed1e-4e57-aee5-2159882ca8a4",
          "refresh_state_part_uuid" => "07d03d71-af2a-461d-8aa2-18b9c39bdc79",
          "collections"             => [
            {"name" => "container_nodes",
             "data" => [
               container_node_data_1,
               container_node_data_2
             ]
            }
          ]
        }
      end

      let(:container_node_data_1) do
        {
          "addresses"          => [{"type"    => "InternalIP",
                                    "address" => "172.31.49.31"},
                                   {"type"    => "ExternalIP",
                                    "address" => "42.42.42.43"},
                                   {"type"    => "InternalDNS",
                                    "address" => "ip-42-42-42-43.ec2.internal"},
                                   {"type"    => "ExternalDNS",
                                    "address" => "ec2-42-42-42-43.compute-1.amazonaws.com"},
                                   {"type"    => "Hostname",
                                    "address" => "ip-172-31-49-31.ec2.internal"}],
          "allocatable_cpus"   => 7.25,
          "allocatable_memory" => 61964136448,
          "allocatable_pods"   => 250,
          "conditions"         => [{"type"               => "KernelDeadlock",
                                    "status"             => "False",
                                    "lastHeartbeatTime"  => "2019-05-14T11:26:19Z",
                                    "lastTransitionTime" => "2019-04-15T21:18:37Z",
                                    "reason"             => "KernelHasNoDeadlock",
                                    "message"            => "kernel has no deadlock"},
                                   {"type"               => "OutOfDisk",
                                    "status"             => "False",
                                    "lastHeartbeatTime"  => "2019-05-14T11:27:03Z",
                                    "lastTransitionTime" => "2019-05-08T01:52:51Z",
                                    "reason"             => "KubeletHasSufficientDisk",
                                    "message"            => "kubelet has sufficient disk space available"},
                                   {"type"               => "MemoryPressure",
                                    "status"             => "False",
                                    "lastHeartbeatTime"  => "2019-05-14T11:27:03Z",
                                    "lastTransitionTime" => "2019-05-08T01:52:52Z",
                                    "reason"             => "KubeletHasSufficientMemory",
                                    "message"            => "kubelet has sufficient memory available"},
                                   {"type"               => "DiskPressure",
                                    "status"             => "False",
                                    "lastHeartbeatTime"  => "2019-05-14T11:27:03Z",
                                    "lastTransitionTime" => "2019-05-08T01:52:52Z",
                                    "reason"             => "KubeletHasNoDiskPressure",
                                    "message"            => "kubelet has no disk pressure"},
                                   {"type"               => "PIDPressure",
                                    "status"             => "False",
                                    "lastHeartbeatTime"  => "2019-05-14T11:27:03Z",
                                    "lastTransitionTime" => "2018-05-24T15:55:24Z",
                                    "reason"             => "KubeletHasSufficientPID",
                                    "message"            => "kubelet has sufficient PID available"},
                                   {"type"               => "Ready",
                                    "status"             => "True",
                                    "lastHeartbeatTime"  => "2019-05-14T11:27:03Z",
                                    "lastTransitionTime" => "2019-05-08T02:01:35Z",
                                    "reason"             => "KubeletReady",
                                    "message"            => "kubelet is posting ready status"}],
          "cpus"               => 8,
          "lives_on"           => {"inventory_collection_name" => "cross_link_vms",
                                   "reference"                 => {"uid_ems" => "i-00000000000421"},
                                   "ref"                       => "manager_ref"},
          "memory"             => 64216477696,
          "name"               => "ip-172-31-49-31.ec2.internal",
          "node_info"          => {"providerID"              => "aws:///us-east-1c/i-00000000000421",
                                   "externalID"              => "i-00000000000421",
                                   "machineID"               => "d52c597d0f1a42aeb01b5a7d71e42011",
                                   "systemUUID"              => "EC21605A-2992-4B13-1BEB-7Iu234641EE3",
                                   "bootID"                  => "714de86c-0275-4b8f-bb88-94f5285s20vc",
                                   "kernelVersion"           => "3.10.0-862.11.6.el7.x86_64",
                                   "osImage"                 => "Red Hat Enterprise Linux",
                                   "containerRuntimeVersion" => "docker://1.13.1",
                                   "kubeletVersion"          => "v1.11.0+d4cacc0",
                                   "kubeProxyVersion"        => "v1.11.0+d4cacc0",
                                   "operatingSystem"         => "linux",
                                   "architecture"            => "amd64"},
          "pods"               => 250,
          "resource_timestamp" => "2019-05-14 11:27:27 UTC",
          "resource_version"   => "360170894",
          "source_created_at"  => "2018-05-24T15:55:24Z",
          "source_ref"         => "def3f4ed-5f6a-11e8-a351-0a0ddbb52ad4"
        }
      end

      let(:container_node_data_2) do
        {
          "addresses"          => nil,
          "allocatable_cpus"   => 3.25,
          "allocatable_memory" => 31313584128,
          "allocatable_pods"   => 160,
          "conditions"         => nil,
          "cpus"               => 4,
          "lives_on"           => {"inventory_collection_name" => "cross_link_vms",
                                   "reference"                 => {"uid_ems" => "i-000000000420"},
                                   "ref"                       => "manager_ref"},
          "memory"             => 33565925376,
          "name"               => "ip-42-42-42-42.ec2.internal",
          "node_info"          => {"providerID"              => "aws:///us-east-1c/i-000000000420",
                                   "machineID"               => "dadsacafsfsafsac2aeb01b5a7d71e63f24",
                                   "systemUUID"              => "EC29FE59-163E-1B20-D25B-06533ED4640A",
                                   "bootID"                  => "74d2d8f5-d2a6-4db2-a552-5t048f7b4200",
                                   "kernelVersion"           => "3.10.0-957.10.1.el7.x86_64",
                                   "osImage"                 => "Red Hat Enterprise Linux",
                                   "containerRuntimeVersion" => "docker://1.13.1",
                                   "kubeletVersion"          => "v1.11.0+d4cacc0",
                                   "kubeProxyVersion"        => "v1.11.0+d4cacc0",
                                   "operatingSystem"         => "linux",
                                   "architecture"            => "amd64"},
          "pods"               => 160,
          "resource_timestamp" => "2019-05-14 11:27:27 UTC",
          "resource_version"   => "360170905",
          "source_created_at"  => "2018-08-17T19:12:47Z",
          "source_ref"         => "86d0bb1e-a251-11e8-8841-0a46c474dfe0"
        }
      end

      let(:container_node_and_group_body) do
        {
          "name"                    => "OCP",
          "schema"                  => {"name" => "Default"},
          "source"                  => "31b5338b-685d-4056-ba39-d00b4d7f19bd",
          "refresh_state_uuid"      => "a2116550-ed1e-4e57-aee5-2159882ca8a4",
          "refresh_state_part_uuid" => "07d03d71-af2a-461d-8aa2-18b9c39bdc79",
          "collections"             => [
            {
              "name" => "container_groups",
              "data" => [
                container_group_data
              ]
            }, {
              "name" => "container_nodes",
              "data" => [
                container_node_data_1,
                container_node_data_2
              ]
            }
          ]
        }
      end

      let(:failed_validation_code) { "400" }

      context "correct payload" do
        it "passes with valid container groups" do
          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          expect(@response.code).to eq("200")
          expect(JSON.parse(@response.body)).to eq({"message" => "ok"})
        end

        it "passes with valid container nodes" do
          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_body), :headers => headers)

          expect(@response.code).to eq("200")
          expect(JSON.parse(@response.body)).to eq({"message" => "ok"})
        end

        it "passes with valid container groups and nodes" do
          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_and_group_body), :headers => headers)

          expect(@response.code).to eq("200")
          expect(JSON.parse(@response.body)).to eq({"message" => "ok"})
        end
      end

      context "type checks" do
        it "fails because we pass integer instead of string" do
          container_group_data["source_ref"] = 15000420

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails because we pass float instead of string" do
          container_group_data["source_ref"] = 15000420.42

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails because we pass integer instead of timestamp" do
          container_group_data["resource_timestamp"] = 15000420

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("This should fail on invalid value, right now it might be coercing to nil and nil is allowed")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails because we pass invalid timestamp" do
          container_group_data["resource_timestamp"] = "2019-04-42T15:35:45Z"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("This should fail on invalid value, right now it might be coercing to nil and nil is allowed")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails because we pass integer instead of float" do
          container_node_data_1["allocatable_cpus"] = 10

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_body), :headers => headers)

          pending("Integer is casted to float automatically, do we want strict check?")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails because we pass string instead of float" do
          container_node_data_1["allocatable_cpus"] = "10.6"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_body), :headers => headers)

          pending("Integer is casted to float automatically, do we want strict check?")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails because we pass bad string instead of float" do
          container_node_data_1["allocatable_cpus"] = "10cows and 6cowboys"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_body), :headers => headers)

          pending("Invalid string is casted to float automatically, do we want strict check?")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails when passing array into type object" do
          container_node_data_1["node_info"] = ["42", "45"]

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_body), :headers => headers)

          pending("Object should be hash, right? For some reason this is passing.")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails when passing hash into type array" do
          container_node_data_1["conditions"] = {"a" => "b"}

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_node_body), :headers => headers)

          pending("We should check array type")
          expect(@response.code).to eq(failed_validation_code)
        end
      end

      context "required inventory object attrs" do
        it "fails on missing required attribute" do
          container_group_data.delete("source_ref")

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails on required NOT NULL attr being null" do
          container_group_data["source_ref"] = nil

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          expect(@response.code).to eq(failed_validation_code)
        end
      end

      context "wrong relation" do
        it "fails on wrong relation name" do
          # Relation container_node must point to "inventory_collection_name" => "container_node", but has
          # "inventory_collection_name" => "container_groups"
          container_group_data["container_node"]["inventory_collection_name"] = "container_groups"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("Right now the anyOf matches wrong InventoryCollection, we need the support for discriminator")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails on wrong relation reference attr" do
          # Reference has a required attr in it, that should be matched
          container_group_data["container_node"]["reference"] = {"made_up_attr" => "made_up_value"}

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("Right now the anyOf matches wrong InventoryCollection, we need the support for discriminator")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails on wrong relation reference ref" do
          # Reference ref can be only "by_name" or "manager_ref"
          container_group_data["container_node"]["reference"] = {"ref" => "by_non_xistent_attr"}

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("Right now the anyOf matches wrong InventoryCollection, we need the support for discriminator")
          expect(@response.code).to eq(failed_validation_code)
        end
      end

      context "inventory object attributes" do
        it "fails on unknown attribute in a collection" do
          # Unless object defines "additionalProperties", validation should fail on unknown attribute
          container_group_data["made_up_attr"] = "made_up_value"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("Right now extra attributes in object are allowed, not respecting additionalProperties")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails on unknown attribute in a relation" do
          # Unless object defines "additionalProperties", validation should fail on unknown attribute
          container_group_data["container_node"]["made_up_attr"] = "made_up_value"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("Right now extra attributes in object are allowed, not respecting additionalProperties")
          expect(@response.code).to eq(failed_validation_code)
        end

        it "fails on unknown attribute in a relation reference" do
          # Unless object defines "additionalProperties", validation should fail on unknown attribute
          container_group_data["container_node"]["reference"]["made_up_attr"] = "made_up_value"

          post("/topological_inventory/ingress_api/0.0.2/inventory", :params => JSON.dump(container_group_body), :headers => headers)

          pending("Right now extra attributes in object are allowed, not respecting additionalProperties")
          expect(@response.code).to eq(failed_validation_code)
        end
      end
    end
  end
end
