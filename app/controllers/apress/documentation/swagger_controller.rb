module Apress
  module Documentation
    class SwaggerController < ::ActionController::Base
      include ::Apress::Documentation::PreloadDocs

      def show
        service = Apress::Documentation::SwaggerJsonBuilder.new(params[:slug])
        data =
          if Rails.application.config.action_controller.perform_caching
            key = ActiveSupport::Cache.expand_cache_key(["swagger_schema", params[:slug]])
            Rails.cache.fetch(key) { service.call }
          else
            service.call
          end

        render json: data
      end

      ActiveSupport.run_load_hooks(:'apress/documentation/swagger_controller', self)
    end
  end
end
