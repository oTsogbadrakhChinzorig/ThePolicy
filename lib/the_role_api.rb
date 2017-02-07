require 'the_policy_api/hash'
require 'the_policy_api/config'
require 'the_policy_api/version'

require 'multi_json'
require 'the_string_to_slug'

module ThePolicy
  module Api; end

  class << self
    def create_admin!
      admin_policy = ::Policy.where(name: :admin).first_or_create!(
        name:        :admin,
        title:       "Policy for admin",
        description: "This user can do anything"
      )
      admin_policy.create_rule(:system, :administrator)
      admin_policy.rule_on(:system, :administrator)
      admin_policy
    end
  end

  class Engine < Rails::Engine
    # Right now I don't know why, but autoload_paths doesn't work here
    # Patch it, if you know how
    if Rails::VERSION::MAJOR == 3
      app = "#{ config.root }/app"
      require_dependency "#{ app }/controllers/concerns/the_policy/controller.rb"
      %w[ base_methods policy user ].each do |file|
        require_dependency "#{ app }/models/concerns/the_policy/api/#{ file }.rb"
      end
    else
      config.autoload_paths << "#{ config.root }/app/models/concerns/**"
      config.autoload_paths << "#{ config.root }/app/controllers/concerns/**"
    end

    initializer "the_policy_precompile_hook", group: :all do |app|
      app.config.assets.precompile += %w(
        the_policy_management_panel.js
        the_policy_management_panel.css
      )
    end
  end
end

# ==========================================================================================
# Just info
# ==========================================================================================
#
# http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
# config.to_prepare do; end
#
# ==========================================================================================
#
# require 'the_policy_api/active_record'
#
# if defined?(ActiveRecord::Base)
#   ActiveRecord::Base.extend ThePolicy::Api::ActiveRecord
# end
#
# ==========================================================================================
#
# A note on Decorators and Loading Code # http://guides.rubyonrails.org/engines.html
#
# config.to_prepare do
#   Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
#     require_dependency(c)
#   end
# end
#
# ==========================================================================================
