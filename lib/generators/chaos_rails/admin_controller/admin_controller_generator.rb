class ChaosRails::AdminControllerGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)

  argument :attributes, type: :array, default: [], banner: 'field:type field:type'

  def create_controller_files
    template_file = 'admin_controller.rb'
    template template_file, File.join('app/admin/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
  end

  hook_for :template_engine, as: :admin_controller do |template_engine|
    # TODO: Right views
    invoke template_engine
  end

  hook_for :resource_route, required: true do |route|
    # TODO: Add the admin route. How?
    invoke route
  end

  hook_for :test_framework, as: :scaffold

  private

  def permitted_params
    attachments, others = attributes_names.partition { |name| attachments?(name) }
    params = others.map { |name| ":#{name}" }
    params += attachments.map { |name| "#{name}: []" }
    params.join(', ')
  end

  def attachments?(name)
    attribute = attributes.find { |attr| attr.name == name }
    attribute&.attachments?
  end
end
