java -jar public/doc/openapi-generator-cli.jar generate \
   -i public/doc/openapi-3-v0.0.2.json \
   -c openapi_config.json \
   -g ruby \
   -o ../topological_inventory-ingress_api-client-ruby
