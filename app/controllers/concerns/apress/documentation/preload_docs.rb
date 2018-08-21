module Apress
  module Documentation
    module PreloadDocs
      extend ActiveSupport::Concern

      included do
        if (Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 2) || Rails::VERSION::MAJOR > 4
          before_action :load_docs
        else
          before_filter :load_docs
        end
      end

      def load_docs
        ActiveSupport.run_load_hooks(:documentation)
        Apress::Documentation.validate_dependencies!
      end
    end
  end
end
