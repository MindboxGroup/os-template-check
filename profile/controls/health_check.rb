# encoding: utf-8
title 'Health check'

control 'health_check' do
  impact 1.0
  desc 'Check whether a template includes health checks'
  title 'Verify health checks'
  tag 'application'
  tag 'livenessprobe'
  tag 'readinessprobe'

  template = yaml('app/template.yaml')
  if template['objects']
    template['objects'].each do |obj|
      if obj['kind'] == 'DeploymentConfig'
        obj['spec']['template']['spec']['containers'].each do |container|
          describe livenessprobe(container['livenessProbe']) do
            its('check') { should cmp true }
          end

          describe readinessprobe(container['readinessProbe']) do
            its('check') { should cmp true }
          end
        end
      end
    end
  end
end
