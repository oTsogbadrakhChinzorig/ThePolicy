module ThePolicy
  def self.configure(&block)
    yield @config ||= ThePolicy::Configuration.new
  end

  def self.config
    @config
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :layout,
                    :destroy_strategy,
                    :default_user_policy,
                    :access_denied_method,
                    :login_required_method,
                    :first_user_should_be_operator
  end

  configure do |config|
    config.layout = :application

    config.default_user_policy          = nil
    config.access_denied_method       = nil
    config.login_required_method      = nil
    config.destroy_strategy           = nil
    config.first_user_should_be_operator = false
  end
end
