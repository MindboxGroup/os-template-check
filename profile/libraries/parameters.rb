require 'yaml'

# Custom resource based on the InSpec resource DSL
class ParametersTemplate < Inspec.resource(1)
  name 'parameters'

  def initialize(template, names)
    @params = template
		@names = names
  end

  def exist?
		if @params['parameters']
			return true
		end
		return false
  end

	def required_parameters
		template_parameters = []

		@params.each do |param|
			template_parameters.push(param['name'])
		end

		@names.each do |name|
			if not template_parameters.include?(name)
				return "Cannot find "+name+" parameter which is required"
			end
		end

		return true
	end
end
