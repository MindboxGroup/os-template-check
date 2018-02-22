# encoding: utf-8
title 'Basic'

control 'basic' do
  impact 1.0
  desc 'Check template basic arguments'
  title 'Verify the basic fields for template'
  tag 'application'
  tag 'template', 'basic'

  describe yaml('app/template.yaml') do
    its('apiVersion') { should match('v1') }
    its('kind') { should match('Template') }
    its(['metadata', 'name']) { should match('') }
    its('objects') { should_not eq nil }
  end
end
