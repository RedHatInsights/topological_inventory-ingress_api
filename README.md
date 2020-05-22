# Topological Inventory Ingress API

[![Build Status](https://travis-ci.org/RedHatInsights/topological_inventory-ingress_api.svg)](https://travis-ci.org/RedHatInsights/topological_inventory-ingress_api)
[![Maintainability](https://api.codeclimate.com/v1/badges/908bba55ba117684bfa3/maintainability)](https://codeclimate.com/github/RedHatInsights/topological_inventory-ingress_api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/908bba55ba117684bfa3/test_coverage)](https://codeclimate.com/github/RedHatInsights/topological_inventory-ingress_api/test_coverage)
[![Security](https://hakiri.io/github/RedHatInsights/topological_inventory-ingress_api/master.svg)](https://hakiri.io/github/RedHatInsights/topological_inventory-ingress_api/master)

This is a project to provide Swagger support inside the [Ruby on Rails](http://rubyonrails.org/) framework.

## Prerequisites
You need to install ruby >= 2.2.2 and run:

```
bundle install
```

## Getting started

This sample was generated with the [swagger-codegen](https://github.com/swagger-api/swagger-codegen) project.

```
bin/rake db:create db:migrate
bin/rails s
```

To list all your routes, use:

```
bin/rake routes
```

## Generate client to any language on any OS using openapi_generator

Follow https://github.com/OpenAPITools/openapi-generator instructions
using the yaml file e.g. `public/doc/swagger-2-v0.0.2.yaml`

## Prerequisities
- Java Runtime Environment (JRE) 8

## Quick setup for ruby client generated on Fedora/RHEL:
```
# Download JAR of latest stable openapi-generator
cd topological_inventory-ingress-api
wget http://central.maven.org/maven2/org/openapitools/openapi-generator-cli/3.3.4/openapi-generator-cli-3.3.4.jar -O public/doc/openapi-generator-cli.jar
```

Fetch the ruby client git repo:
 
```
git clone git@github.com:RedHatInsights/topological_inventory-ingress_api-client-ruby.git
```

Build the client:

```
 cd topological_inventory-ingress-api
 ./generate_ruby_client.sh
 
 cd ../topological_inventory-ingress_api-client-ruby
 # and commit&push the client changes
```

## License

This project is available as open source under the terms of the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).
