module ThePolicy
  module Api
    module BaseMethods
      def has_section? section_name
        hash         =  policy_hash
        section_name =  section_name.to_slug_param(sep: '_')
        return true  if hash[section_name]

        false
      end

      def has_policy? section_name, rule_name
        hash         =  policy_hash
        section_name =  section_name.to_slug_param(sep: '_')
        rule_name    =  rule_name.to_slug_param(sep: '_')

        return true  if hash.try(:[], 'system').try(:[], 'operator')
        return true  if hash.try(:[], 'admin').try(:[], section_name)

        return false unless hash[section_name]
        return false unless hash[section_name].key? rule_name

        hash[section_name][rule_name]
      end

      def any_policy? policys_hash = {}
        policys_hash.each_pair do |section, rules|
          return false unless[ Array, String, Symbol ].include?(rules.class)
          return has_policy?(section, rules) if [ String, Symbol ].include?(rules.class)
          rules.each{ |rule| return true if has_policy?(section, rule) }
        end

        false
      end

      def admin? section_name
        section_name = section_name.to_slug_param(sep: '_')
        has_policy? section_name, 'any_crazy_name'
      end

      def operator?
        has_policy? 'any_crazy_name', 'any_crazy_name'
      end
    end
  end
end
