class InteractionGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_usecase_file
    template 'interaction.rb.erb', "app/interactions/#{file_name}.rb"
  end

  private

  def file_name
    underscore_name = name.underscore
    return underscore_name if underscore_name.match('_interaction')

    underscore_name
  end

  def interaction_name
    camelized_name = name.camelize

    camelized_name
  end
end
