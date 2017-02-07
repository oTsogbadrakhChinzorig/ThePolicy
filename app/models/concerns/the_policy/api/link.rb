module ThePolicy
  module Api
    # Link with User module
    module Link
      extend ActiveSupport::Concern

      include ThePolicy::Api::BaseMethods

      # HELPERS

      # version for `Link`  model
      def policy_hash
        @policy_hash ||= policy.try(:to_hash) || {}
      end

      # ~ HELPERS

      included do
        belongs_to :policy
        before_validation :set_default_policy, on: :create
        after_save { |user| user.instance_variable_set(:@policy_hash, nil) }
      end

      module ClassMethods
        def with_policy name
          ::Policy.where(name: name).first.users
        end
      end

      # FALSE if object is nil
      # If object is a USER - check for youself
      # Check for owner field - :user_id
      # Check for owner _object_ if owner field is not :user_id
      def owner? obj
        return false unless obj
        return true  if operator?

        section_name = obj.class.to_s.tableize
        return true if admin?(section_name)

        # obj is User, simple way to define user_id
        return id == obj.id if obj.is_a?(self.class)

        # few ways to define user_id
        return id == obj.user_id     if obj.respond_to? :user_id
        return id == obj[:user_id]   if obj[:user_id]
        return id == obj[:user][:id] if obj[:user]

        false
      end

      private

      def set_default_policy
        unless policy
          default_policy = ::Policy.find_by_name(ThePolicy.config.default_user_policy)
          self.policy = default_policy if default_policy
        end

        if self.class.count.zero? && ThePolicy.config.first_user_should_be_operator
          self.policy = ThePolicy.create_operator!
        end
      end
    end
  end
end
