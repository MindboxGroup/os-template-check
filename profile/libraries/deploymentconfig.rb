# Custom resource based on the InSpec resource DSL
class DeploymentConfigResource < Inspec.resource(1)
  name 'deploymentconfig'

  def initialize(template)
    @params = template
  end

  def exists?
    if @params['objects']
      @params['objects'].each do |obj|
        if obj['kind'] == 'DeploymentConfig'
          return true
        end
      end
    end
    return false
  end
end
