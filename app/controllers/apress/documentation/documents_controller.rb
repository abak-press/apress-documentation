module Apress
  module Documentation
    class DocumentsController < ActionController::Base
      include ::Apress::Documentation::PreloadDocs
      layout 'documentation'

      def show
        @document = Apress::Documentation.fetch_document(params[:path]) if params[:path]
      end

      ActiveSupport.run_load_hooks(:'apress/documentation/documents_controller', self)
    end
  end
end
