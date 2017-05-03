require 'spec_helper'

describe Apress::Documentation::SwaggerUiController, type: :controller do
  describe '#show' do
    it 'response with 200' do
      get :show

      expect(response).to have_http_status(:ok)
    end
  end
end
