module ThePolicy
  module Api
    module Policy
      extend ActiveSupport::Concern

      include ThePolicy::Api::BaseMethods

      # HELPERS

      # version for `Policy` model
      def policy_hash
        to_hash
      end

      def the_policy= val
        self[:the_policy] = _jsonable val
      end

      def _jsonable val
        val.is_a?(Hash) ? val.to_json : val.to_s
      end

      def to_hash
        begin JSON.load(the_policy) rescue {} end
      end

      def to_json
        the_policy
      end

      # ~ HELPERS

      alias_method :has?, :has_policy?
      alias_method :any?, :any_policy?

      def has_section? section_name
        to_hash.key? section_name.to_slug_param(sep: '_')
      end

      included do
        attr_accessor :based_on_policy

        has_many  :users, dependent: ThePolicy.config.destroy_strategy
        validates :name,  presence: true, uniqueness: true
        validates :title, presence: true, uniqueness: true
        validates :description, presence: true

        private

        before_save do
          self.name = name.to_slug_param(sep: '_')

          rules_set     = self.the_policy
          self.the_policy = {}.to_json        if rules_set.blank?
          self.the_policy = rules_set.to_json if rules_set.is_a?(Hash)
        end

        after_create do
          if based_on_policy.present?
            if base_policy = self.class.where(id: based_on_policy).first
              update_policy base_policy.to_hash
            end
          end
        end
      end

      module ClassMethods
        def with_name name
          ::Policy.where(name: name).first
        end
      end

      # C

      def create_section section_name = nil
        return false unless section_name

        policy         = to_hash
        section_name = section_name.to_slug_param(sep: '_')

        return false if section_name.blank?
        return true  if policy[section_name]

        policy[section_name] = {}
        update_attribute(:the_policy, _jsonable(policy))
      end

      def create_rule section_name, rule_name
        return false if     rule_name.blank?
        return false unless create_section(section_name)

        policy         = to_hash
        rule_name    = rule_name.to_slug_param(sep: '_')
        section_name = section_name.to_slug_param(sep: '_')

        return true if policy[section_name][rule_name]

        policy[section_name][rule_name] = false
        update_attribute(:the_policy,  _jsonable(policy))
      end

      # U

      # source_hash will be reset to false
      # except true items from new_policy_hash
      # all keys will become 'strings'
      # look at lib/the_policy/hash.rb to find definition of *underscorify_keys* method
      def update_policy new_policy_hash
        new_policy_hash = new_policy_hash.try(:to_hash) || {}

        new_policy = new_policy_hash.underscorify_keys
        policy     = to_hash.underscorify_keys.deep_reset(false)

        policy.deep_merge! new_policy
        update_attribute(:the_policy,  _jsonable(policy))
      end

      def rule_on section_name, rule_name
        policy         = to_hash
        rule_name    = rule_name.to_slug_param(sep: '_')
        section_name = section_name.to_slug_param(sep: '_')

        return false unless policy[section_name]
        return false unless policy[section_name].key? rule_name
        return true  if     policy[section_name][rule_name]

        policy[section_name][rule_name] = true
        update_attribute(:the_policy,  _jsonable(policy))
      end

      def rule_off section_name, rule_name
        policy         = to_hash
        rule_name    = rule_name.to_slug_param(sep: '_')
        section_name = section_name.to_slug_param(sep: '_')

        return false unless policy[section_name]
        return false unless policy[section_name].key? rule_name
        return true  unless policy[section_name][rule_name]

        policy[section_name][rule_name] = false
        update_attribute(:the_policy,  _jsonable(policy))
      end

      # D

      def delete_section section_name = nil
        return false unless section_name

        policy = to_hash
        section_name = section_name.to_slug_param(sep: '_')

        return false if section_name.blank?
        return false unless policy[section_name]

        policy.delete section_name
        update_attribute(:the_policy,  _jsonable(policy))
      end

      def delete_rule section_name, rule_name
        policy         = to_hash
        rule_name    = rule_name.to_slug_param(sep: '_')
        section_name = section_name.to_slug_param(sep: '_')

        return false unless policy[section_name]
        return false unless policy[section_name].key? rule_name

        policy[section_name].delete rule_name
        update_attribute(:the_policy,  _jsonable(policy))
      end
    end
  end
end
