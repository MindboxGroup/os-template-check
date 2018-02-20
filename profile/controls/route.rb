# encoding: utf-8
title 'Route'

control 'route' do
	impact 1.0
  desc 'Check route'
  title 'Verify route resource'
  tag 'application'
	tag 'route'

  template = yaml('app/template.yaml')

	only_if do
		route(template).exist?
	end

	if template['objects']
		template['objects'].each do |obj|
			if obj['kind'] == 'Route'
				describe obj do
					its(['apiVersion']) {should match('v1')}
					its(['metadata', 'name']) {should match('')}
					its(['spec', 'port', 'targetPort']) {should match('')}
					its(['spec', 'tls', 'termination']) {should match('edge')}
					its(['spec', 'to', 'kind']) {should match('Service')}
					its(['spec', 'to', 'name']) {should match('')}
					its(['spec', 'to', 'weight']) {should > 0}
				end
			end
		end
	end

end
