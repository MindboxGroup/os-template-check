require 'yaml'

# Custom resource based on the InSpec resource DSL
class RouteResource < Inspec.resource(1)
  name 'route'

  def initialize(template)
    @params = template
  end

  def exist?
		if @params['objects']
			@params['objects'].each do |obj|
				if obj['kind'] == 'Route'
					return true
				end
			end
		end
		return false
  end
end
