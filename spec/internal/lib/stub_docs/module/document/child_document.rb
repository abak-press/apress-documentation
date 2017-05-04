Apress::Documentation.build(:test_load_module) do
  document :document do
    document :child do
      description 'Cool document'
    end
  end
end
