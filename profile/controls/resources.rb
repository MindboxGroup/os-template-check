# encoding: utf-8
title 'Resources'

control 'resources' do
	impact 1.0
  desc 'Checks whether a template includes resources arguments'
  title 'Verify whether container has had set resources'
  tag 'application'
	tag 'resources'

  template = yaml('app/template.yaml')
	if template['objects']
		template['objects'].each do |obj|
			if obj['kind'] == 'DeploymentConfig'
				obj['spec']['template']['spec']['containers'].each do |container|

					describe container['resources'] do
						its(['requests', 'cpu']) {should cmp >= 0.1}
						its(['requests', 'memory']) {should_not cmp ''}
						its(['limits', 'memory']) {should_not cmp ''}
					end

				end
			end
		end
	end

end
