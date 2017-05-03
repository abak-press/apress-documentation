class StubRoot < ::Apress::Documentation::Swagger::Schema
  swagger_root do
    key :swagger, '2.0'
    key :basePath, '/api/v1'
    key :produces, ['application/json']
  end
end
