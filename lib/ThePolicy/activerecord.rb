module ThePolicy
  module Api
    module ActiveRecord
      def has_the_policy
        include ThePolicy::Api::Link
      end

      def acts_as_the_policy
        include ThePolicy::Api::Policy
      end
    end
  end
end
