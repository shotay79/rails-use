class ApiGenerator < Rails::Generators::NamedBase
  argument :actions, type: :array, default: [], banner: "action action"
  source_root File.expand_path('templates', __dir__)

  def create_controller_files
    @usecase_prefix = usecase_prefix
    @parent_controller_name = parent_controller_name
    template "controller.rb.erb",
      File.join("app/controllers", class_path, "#{file_name}_controller.rb")
  end

  def create_interaction_files
    actions.each do |action|
      @interaction_name = interaction_name(action)
      @parent_class_name = parent_class_name
      path = File.join(
        "app/interactions", class_path, "#{@interaction_name.underscore}.rb"
      )
      template "interaction.rb.erb", path
    end
  end

  def create_spec_files
    @operator = operator
    template "request.rb.erb",
      File.join("spec/requests", class_path, "#{file_name}_spec.rb")
  end

  def create_serializer
    serializer_name
    # serializerが存在しない場合は作成する

  end

  private

  # 継承するコントローラーの名前を取得する
  def parent_controller_name
    return 'V1::AdminUsers::ApplicationController' if class_path.include?('admin_users')
    return 'V1::Users::ApplicationController' if class_path.include?('users')
    return 'V1::Public::ApplicationController' if class_path.include?('public')
    raise '継承するコントローラーが見つかりませんでした'
  end

  def operator
    return 'admin_user' if class_path.include?('admin_users')
    return 'user' if class_path.include?('users')
    return '' if class_path.include?('public')
    raise 'operatorが見つかりませんでした'
  end

  def serializer_name
    resource_name = class_name.split('::').last.singularize.underscore
    @serializer_name = "#{resource_name}_serializer"
    serializer_file_name = "#{@serializer_name}.rb"
    unless File.exist?("#{Rails.root}/app/serializers/#{serializer_file_name}")
      template "serializer.rb.erb", File.join("app/serializers", class_path, "#{serializer_file_name}")
    end
  end

  def interaction_name(action)
    names = class_name.split('::')
    names.shift
    prefix = usecase_prefix.dig(action.to_sym) || action.camelize

    name = if action == 'index'
             names.last.pluralize
           else
             names.last.singularize
           end

    "#{prefix}#{name}Interaction"
  end

  def parent_class_name
    return 'V1::AdminUsers::Base' if class_path.include?('admin_users')
    return 'V1::Users::Base' if class_path.include?('users')
    return 'V1::Public::Base' if class_path.include?('public')
    raise '継承するクラスが見つかりませんでした'
  end

  def usecase_prefix
    {
      index: 'Fetch',
      show: 'Find',
      create: 'Create',
      update: 'Update',
      destroy: 'Destroy',
    }
  end

  def method_name(action_name)
    return 'get' if ['index', 'show'].include?(action_name)
    return 'post' if action_name == 'create'
    return 'put' if action_name == 'update'
    return 'delete' if action_name == 'destroy'
    'get'
  end

  def end_point(action_name)
    resouce_name = class_name.split('::').last.underscore.singularize
    base_path = class_name.split('::').map(&:underscore).join('/').gsub('public/', '')
    class_name.split('::')
    return base_path if ['index', 'create'].include?(action_name)
    if ['show', 'update', 'destory'].include?(action_name)
      return base_path + '/#{' + resouce_name + '.id}'
    end
    base_path
  end
end
