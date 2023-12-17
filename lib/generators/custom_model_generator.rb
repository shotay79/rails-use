class CustomModelGenerator < Rails::Generators::NamedBase
  def generate_model
    generate "model #{name}"
    generate "serializer #{name}"
    generate "factory_bot:model #{name}"
  end
end
