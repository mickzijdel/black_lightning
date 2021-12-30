require "rails/generators/rails/scaffold/scaffold_generator"

class ChaosRails::ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
  remove_hook_for :scaffold_controller
  remove_hook_for :assets

  hook_for :admin_controller

  hook_for :fixtures

  hook_for :test_framework, as: :scaffold
end
