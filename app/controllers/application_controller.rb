class ApplicationController < ActionController::API
  before_action :validate_request

  def body_params
    return @body_params if @body_params.present?

    @body_params = JSON.parse(request.body.read)
  end

  # Validates against openapi.json
  # - only for HTTP POST/PATCH
  def validate_request
    return unless request.post? || request.patch?

    self.class.send(:api_doc).validate!(request.method,
                                        request.path,
                                        self.class.send(:api_version),
                                        body_params)
  rescue OpenAPIParser::OpenAPIError => exception
    render :json   => {:message    => exception.message,
                       :error_code => exception.class.to_s},
           :status => :bad_request
  end

  private_class_method def self.api_version
    @api_version ||= name.split("::")[2].downcase[1..-1].gsub(/x/, ".")
  end

  private_class_method def self.api_doc
    return @api_doc if @api_doc.present?

    # Insights::Api::Common::Docs caches only major:minor version
    version_parts = api_version.split('.')
    doc_api_version = if version_parts.size > 2
                        version_parts[0..1].join('.')
                      else
                        api_version
                      end

    @api_doc = TopologicalInventory::IngressApi::Docs[doc_api_version]
  end
end
