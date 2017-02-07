require 'ThePolicy/hash'
require 'ThePolicy/config'
require 'ThePolicy/version'

require 'multi_json'
require 'the_string_to_slug'

module ThePolicy
    module Api; end

    class << self
      def create_operator!
          operator_policy = ::Policy.where(name: :operator).first_or_create!(
              name:        :operator,
              title:       'Policy for operator',
              description: 'This user can do anything'
          )
          operator_policy.create_rule(:system, :operator)
          operator_policy.rule_on(:system, :operator)
          operator_policy
      end
    end

    class Engine < Rails::Engine
        # Right now I don't know why, but autoload_paths doesn't work here
        # Patch it, if you know how
        if Rails::VERSION::MAJOR == 3
            app = "#{config.root}/app"
            require_dependency "#{app}/controllers/concerns/the_policy/controller.rb"
            %w(base_methods policy link).each do |file|
                require_dependency "#{app}/models/concerns/the_policy/api/#{file}.rb"
            end
        else
            config.autoload_paths << "#{config.root}/app/models/concerns/**"
            config.autoload_paths << "#{config.root}/app/controllers/concerns/**"
        end

        initializer 'the_policy_precompile_hook', group: :all do |app|
            app.config.assets.precompile += %w(
                the_policy_management_panel.js
                the_policy_management_panel.css
            )
        end
    end
end
