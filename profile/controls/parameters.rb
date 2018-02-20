# encoding: utf-8
title 'Parameters'

control 'parameters' do
	impact 1.0
  desc 'Check parameters'
  title 'Verify parameters in a template'
  tag 'application'
	tag 'parameters'

	required_parameters =	[
		'PROJECT'
	]

  template = yaml('app/template.yaml')

	if template['parameters']
		describe parameters(template['parameters'], required_parameters) do
			its('required_parameters') { should cmp true}
		end

		template['parameters'].each do |parameter|
			describe parameter do
				its(['name']) {should_not cmp ''}
				its(['description']) {should_not cmp ''}
			end
		end
	end

end
