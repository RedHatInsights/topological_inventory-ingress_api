java -jar public/doc/openapi-generator-cli.jar generate \
   -i public/doc/swagger-2-v0.0.2.yaml \
   -c openapi_config.json \
   -g ruby \
   -o ../topological_inventory-ingress_api-client-ruby
