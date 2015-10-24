# encoding: utf-8

module ParentIssueDoneRatio
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        alias_method_chain :done_ratio, :parent_issue
        alias_method_chain :update_done_ratio_from_issue_status, :parent_issue

        before_save :recalculate_done_ratio
      end
    end

    module InstanceMethods

      PARENT_DONE_RATIO_OPTIONS = %w(default always_calculate up_to_default)

      def done_ratio_with_parent_issue
        if override_behavior?
          read_attribute(:done_ratio)
        else
          done_ratio_without_parent_issue
        end
      end

      def update_done_ratio_from_issue_status_with_parent_issue
        if !override_behavior?
          update_done_ratio_from_issue_status_without_parent_issue
        end
      end

      def recalculate_done_ratio

        if override_behavior? && done_ratio_derived?
          unless Issue.use_status_for_done_ratio? && status && status.default_done_ratio && !children?
            leaves_count = leaves.count
            if leaves_count > 0
              average = leaves.where("estimated_hours > 0").average(:estimated_hours).to_f
              if average == 0
                average = 1
              end
              done = leaves.joins(:status).
                sum("COALESCE(CASE WHEN estimated_hours > 0 THEN estimated_hours ELSE NULL END, #{average}) " +
                    "* (CASE WHEN is_closed = #{self.class.connection.quoted_true} THEN 100 ELSE COALESCE(done_ratio, 0) END)").to_f
              progress = done / (average * leaves_count) * done_ratio_factor
              self.done_ratio = progress.round
            end
          end
        end

        true
      end

      def override_behavior?
        children? && setting_value != 'default'
      end

      def done_ratio_factor
        case setting_value
        when 'up_to_default' then ((status.default_done_ratio || 100) / 100.0)
        else                     1.0
        end
      end

      def setting_value
        Setting.plugin_redmine_parent_issue_done_ratio['parent_done_ratio']
      end

    end
  end
end
