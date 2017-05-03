module Apress
  module Documentation
    module PreloadDocs
      extend ActiveSupport::Concern

      included do
        before_filter :load_docs
      end

      def load_docs
        ActiveSupport.run_load_hooks(:documentation)
      end
    end
  end
end
