# encoding: utf-8
title 'Service'

control 'service' do
	impact 1.0
  desc 'Check service resource'
  title 'Verify service resource'
  tag 'application'
	tag 'service'

  template = yaml('app/template.yaml')

	only_if do
		service_resource(template).exist?
	end

	if template['objects']
		template['objects'].each do |obj|
			if obj['kind'] == 'Service'
				describe obj do
					its(['apiVersion']) {should match('v1')}
					its(['metadata', 'name']) {should match('')}
					its(['spec', 'selector']) {should_not be nil}
					its(['spec', 'type']) {should cmp /ClusterIP|LoadBalancer|NodePort|ExternalName/}
				end

				obj['spec']['ports'].each do |port|
					describe port do
						its(['name']) {should_not cmp ''}
						its(['port']) {should_not cmp ''}
						its(['protocol']) {should cmp /UDP|TCP/}
						its(['targetPort']) {should_not cmp ''}
					end
				end

			end
		end
	end

end
