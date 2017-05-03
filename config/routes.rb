Rails.application.routes.draw do
  scope module: :apress, constraints: {domain: :current} do
    scope module: :documentation do
      get "/documentation/(*path)", to: 'documents#show', as: :documentation
    end

    scope path: :api do
      scope module: :documentation do
        resource :swagger, controller: :swagger_ui, only: :show
        resource :docs, controller: :swagger, only: :show
      end
    end
  end
end
