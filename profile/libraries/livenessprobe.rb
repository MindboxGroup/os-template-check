require 'yaml'

# Custom resource based on the InSpec resource DSL
class LivenessProbe < Inspec.resource(1)
  name 'livenessprobe'

  def initialize(livenessprobe)
    @params = livenessprobe
  end

  def check
    if @params == nil
      return "livenessProbe is not defined"
    elsif not @params['failureThreshold'] > 0
      return "failureThreshold is not > 0"
    elsif not @params['initialDelaySeconds'] > 0
      return "initialDelaySeconds is not > 0"
    elsif not @params['periodSeconds'] > 0
      return "periodSeconds is not > 0"
    elsif not @params['successThreshold'] > 0
      return "successThreshold is not > 0"
    elsif not @params['timeoutSeconds'] > 0
      return "timeoutSeconds is not > 0"
    end

    return true
  end
end
