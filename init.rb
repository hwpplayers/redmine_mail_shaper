require 'redmine'
require 'redmine_mail_shaper'
require 'unified_diff'


Redmine::Plugin.register :redmine_mail_shaper do
  name 'Redmine Mail Shaper plugin'
  author 'Onur Küçük'
  description 'Format and behaviour changer plugin for Redmine notification e-mails '
  version '0.1.0'
  url 'http://www.ozguryazilim.com.tr'
  author_url 'http://www.ozguryazilim.com.tr'
  requires_redmine :version_or_higher => '1.4.0' # not tested with versions below

  settings :partial => 'redmine_mail_shaper/settings',
    :default => {
      :wiki_diff_on_update => 1,
      :wiki_diff_on_create => 1
  }

end


require 'dispatcher'

Dispatcher.to_prepare :redmine_mail_shaper do
  unless IssuesHelper.included_modules.include?(RedmineMailShaper::Patches::IssuesHelperMailShaperPatch)
    IssuesHelper.send(:include, RedmineMailShaper::Patches::IssuesHelperMailShaperPatch)
  end
end


