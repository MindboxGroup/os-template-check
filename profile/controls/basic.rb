# encoding: utf-8
title 'Template'

control 'template' do
  impact 1.0
  desc 'Check template basic arguments'
  title 'Verify the basic fields for template'
  tag 'application'
  tag 'template'

  describe yaml('app/template.yaml') do
    its('apiVersion') { should match('v1') }
    its('kind') { should match('Template') }
    its(['metadata', 'name']) { should_not be nil }
  end
end
