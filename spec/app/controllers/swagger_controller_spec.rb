require 'spec_helper'

def form_params(p)
  if Rails::VERSION::MAJOR > 4
    {params: p}
  else
    p
  end
end

describe Apress::Documentation::SwaggerController, type: :controller do
  describe '#show' do
    it 'response with 200' do
      get :show

      expect(response).to have_http_status(:ok)
    end

    context 'with params' do
      it 'response ok' do
        get :show, form_params(module: 'somemodule')

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with cache' do
      around do |example|
        begin
          Rails.application.config.action_controller.perform_caching = true
          example.run
        ensure
          Rails.application.config.action_controller.perform_caching = false
        end
      end

      it 'caches documentation json' do
        spy = Apress::Documentation::SwaggerJsonBuilder.new(nil)
        allow(Apress::Documentation::SwaggerJsonBuilder).to receive(:new).and_return(spy)
        expect(spy).to receive(:call).once.and_call_original
        get :show
        get :show
      end
    end
  end
end
