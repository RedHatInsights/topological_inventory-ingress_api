# Swagger for Rails 5

[![Build Status](https://travis-ci.org/ManageIQ/topological_inventory-api.svg)](https://travis-ci.org/ManageIQ/topological_inventory-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/47776e67dbb7cc572c3b/maintainability)](https://codeclimate.com/github/ManageIQ/topological_inventory-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/47776e67dbb7cc572c3b/test_coverage)](https://codeclimate.com/github/ManageIQ/topological_inventory-api/test_coverage)
[![Security](https://hakiri.io/github/ManageIQ/topological_inventory-ingress_api/master.svg)](https://hakiri.io/github/ManageIQ/topological_inventory-ingress_api/master)

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

## Quick setup for ruby client generated on Fedora/RHEL:
Install java 8:

``` 
 yum search java | grep openjdk
 yum install java-1.8.0-openjdk-headless.x86_64
 yum install java-1.8.0-openjdk-devel.x86_64
```

Install maven:

``` 
 # Download maven bin tar from http://maven.apache.org/download.cgi
 sudo tar xzf apache-maven-3.6.0-bin.tar.gz /opt/apache-maven-3.6.0
 sudo ln -s /opt/apache-maven-3.6.0 /opt/maven
 
 sudo vi /etc/profile.d/maven.sh
 # and add:
 export M2_HOME=/opt/maven
 export PATH=${M2_HOME}/bin:${PATH}
 
 # then
 source /etc/profile.d/maven.sh
```

Get the openapi-generator:

```
 git clone https://github.com/openapitools/openapi-generator
 cd openapi-generator
 mvn clean package
 cd ..
```

Fetch the ruby client git repo:
 
```
git clone git@github.com:ManageIQ/topological_inventory-ingress_api-client-ruby.git
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
