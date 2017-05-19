module Apress
  module Documentation
    module DocumentsHelper
      def document_url_with_swagger(document)
        if document.is_a?(Apress::Documentation::Storage::SwaggerDocument)
          js_path = "#!/#{document.tag}/#{document.operation_id}"
          documentation_url(path: document.document.slug.to_s) + js_path
        else
          documentation_url(path: document.slug.to_s)
        end
      end
    end
  end
end
