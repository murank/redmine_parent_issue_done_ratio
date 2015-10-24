require 'redmine'
require 'issue_patch'

Redmine::Plugin.register :redmine_parent_issue_done_ratio do
  name 'Redmine Parent Issue Done Ratio plugin'
  author 'murank'
  description 'This plugin allows you to calculate the done ratio of the parent issue from its children, even if you explicitly set the done ratio.'
  version '3.1.1'
  url 'https://github.com/murank/redmine_parent_issue_done_ratio'
  author_url 'https://github.com/murank/'

  settings :default => {
    'parent_done_ratio' => 'default',
  }, :partial => 'settings/done_ratio_settings'
end


Rails.configuration.to_prepare do

  unless Issue.included_modules.include?(ParentIssueDoneRatio::IssuePatch)
    Issue.send(:include, ParentIssueDoneRatio::IssuePatch)
  end

end

