# encoding: utf-8
title 'DeploymentConfig'

control 'deploymentConfig' do
  impact 1.0
  desc 'Checks whether a template includes DeploymentConfig'
  title 'Verify whether a template contain DeploymentConfig resource'
  tag 'application'
  tag 'deploymentconfig'

  template = yaml('app/template.yaml')

  # checks whether DeploymentConfig resource exists
  describe deploymentconfig(template) do
    it { should exist }
  end
end
