module Apress
  module Documentation
    class SwaggerUiController < ::ActionController::Base
      def show
        render 'show', layout: false
      end

      ActiveSupport.run_load_hooks(:'apress/documentation/swagger_ui_controller', self)
    end
  end
end
