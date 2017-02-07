# ThePolicy.config.param_name => value

ThePolicy.configure do |config|
  # [ Devise => :authenticate_user! | Sorcery => :require_login ]
  # config.login_required_method = :authenticate_user!

  # layout for Management panel
  # config.layout = :the_policy_management_panel

  # config.default_user_policy          = nil
  # config.first_user_should_be_operator = false
  # config.access_denied_method       = :access_denied

  # Dependent of Rails::VERSION
  #
  # [ :destroy, :delete_all, :nullify, :restrict, :restrict_with_exception, :restrict_with_error ]
  # config.destroy_strategy = nil
end
