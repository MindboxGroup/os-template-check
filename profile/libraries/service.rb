require 'yaml'

# Custom resource based on the InSpec resource DSL
class ServiceResource < Inspec.resource(1)
  name 'service_resource'

  def initialize(template)
    @params = template
  end

  def exist?
		if @params['objects']
			@params['objects'].each do |obj|
				if obj['kind'] == 'Service'
					return true
				end
			end
		end
		return false
  end
end
