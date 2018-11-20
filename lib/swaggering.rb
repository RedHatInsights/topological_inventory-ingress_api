require 'json'
require 'sinatra/base'
require 'sinatra/cross_origin'

class Configuration
  attr_accessor :base_path, :api_version, :swagger_version, :format_specifier

  def initialize
    @api_version = '1.0'
    @base_path = 'http://localhost:4567'
    @swagger_version = '1.1'
    @format_specifier = ".json"
  end
end

class Swaggering < Sinatra::Base
  register Sinatra::CrossOrigin

  @routes = {}
  @configuration = Configuration.new

  attr_accessor :configuration

  def self.configure
    set    :server, "thin"
    enable :logging

    get("/resources" + @configuration.format_specifier) do
      cross_origin
      Swaggering.to_resource_listing
    end

    # for swagger.yaml
    get("/swagger.yaml") do
      cross_origin
      File.read("./swagger.yaml")
    end

    @configuration ||= Configuration.new
    yield(@configuration) if block_given?
  end

  def self.add_route(method, path, swag = {}, opts = {}, &block)
    # full_path = swag["resourcePath"].to_s + @configuration.format_specifier + path
    full_path = path.gsub(/{(.*?)}/, ':\1')

    accepted =
      case method.to_s.downcase
      when 'get'
        get(full_path, opts, &block)
        true
      when 'post'
        post(full_path, opts, &block)
        true
      when 'delete'
        delete(full_path, opts, &block)
        true
      when 'put'
        put(full_path, opts, &block)
        true
      else
        puts "Error adding route: #{method} #{full_path}"
        false
      end

    if accepted
      resource_path = swag["resourcePath"].to_s
      ops = @routes[resource_path]
      if ops.nil?
        ops = []
        @routes[resource_path] = ops

        get(resource_path + @configuration.format_specifier) do
          cross_origin
          Swaggering.to_api(resource_path)
        end
      end

      swag["httpMethod"] = method.to_s.upcase
      ops.push(swag)
    end
  end

  def self.to_resource_listing
    apis = @routes.keys.collect do |key|
      {
        "path"        => "#{key}.{format}",
        "description" => "no description"
      }
    end

    resource = {
      "apiVersion"     => @configuration.api_version,
      "swaggerVersion" => @configuration.swagger_version,
      "apis"           => apis
    }
    resource.to_json
  end

  def self.to_api(resource_path)
    apis   = {}
    models = []

    @routes[resource_path].each do |route|
      endpoint = route["endpoint"].gsub(/:(\w+)(\/?)/, '{\1}\2')
      path = "#{resource_path}.{format}#{endpoint}"
      api = apis[path]
      if api.nil?
        api = {"path" => path, "description" => "description", "operations" => []}
        apis[path] = api
      end

      parameters = route["parameters"]

      parameters&.each do |param|
        av_string = param["allowableValues"]
        if av_string&.include?('[')
          pattern = /^([A-Z]*)\[(.*)\]/
          match = pattern.match(av_string)
          case match[1]
          when "LIST"
            allowables = match[2].split(',')
            param["allowableValues"] = {
              "valueType" => "LIST",
              "values"    => allowables
            }
          when "RANGE"
            allowables = match[2].split(',')
            param["allowableValues"] = {
              "valueType" => "RANGE",
              "min"       => allowables[0],
              "max"       => allowables[1]
            }
          end
        end
      end

      op = {
        "httpMethod"    => route["httpMethod"],
        "description"   => route["summary"],
        "responseClass" => route["responseClass"],
        "notes"         => route["notes"],
        "nickname"      => route["nickname"],
        "summary"       => route["summary"],
        "parameters"    => route["parameters"]
      }
      api["operations"].push(op)
    end

    api_listing = {
      "apiVersion"     => @configuration.api_version,
      "swaggerVersion" => @configuration.swagger_version,
      "basePath"       => @configuration.base_path,
      "resourcePath"   => resource_path,
      "apis"           => apis.values,
      "models"         => models
    }
    api_listing.to_json
  end
end
