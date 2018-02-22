# InSpec Profile

This InSpec profile is used to test the application template for openshift.


# Controls

In the [control](controls) directory there are files with the control definition that is carried out on the template. Below you can find tables with the list of controls and their description.

 Inspection name | Description
-----------------|-----
 [`basic`](controls/basic.rb) | tests whether the given file is actually a template for openshift
 [`health_check`](controls/health_check.rb) | tests whether the application container contains `livenessProbe` and` readinessProbe`
 [`parameters`](controls/parameters.rb) | tests whether the template contains the required parameters
 [`resources`](controls/resources.rb) | tests whether the container has the resources set that are required by the applications
 [`route`](controls/route.rb) | tests whether the `route` resource contains errors
 [`service`](controls/service.rb) | tests whether the `service` resource contains errors
 [`deploymentconfig`](controls/deploymentconfig.rb) | tests whether the `DeploymentConfig` resource contains errors

## basic

The `basic` control checks whether the given file is the application's template for openshift.

```yaml
apiVersion: v1 #  api version must be  'v1'
kind: Template # kind has to be 'Template'
metadata:
  name: our_application # template name must not be empty
```

## health_check

The health_check control checks if the container contains check `livenessProbe` and` readinessProbe`.

```yaml
[...]
           livenessProbe:
             failureThreshold: 3 # value must be greater than 0
             HttpGet:
               path: / healthcheck
               port: 8080
               scheme: HTTP
             initialDelaySeconds: 180 # value must be greater than 0
             periodSeconds: 10 # value must be greater than 0
             successThreshold: 1 # value must be greater than 0
             timeoutSeconds: 1 # value must be greater than 0
           readinessProbe:
             failureThreshold: 3 # value must be greater than 0
             HttpGet:
               path: / healthcheck
               port: 8080
               scheme: HTTP
             initialDelaySeconds: 60 # value must be greater than 0
             periodSeconds: 10 # value must be greater than 0
             successThreshold: 1 # value must be greater than 0
             timeoutSeconds: 1 # value must be greater than 0
[...]
```

### Library

Do kontroli jest używana metoda `check` która znajduje się w bibliotece [`libraries/livenessprobe.rb`](libraries/livenessprobe.rb).
The check method uses the `check` method found in the library [`libraries/livenessprobe.rb`](libraries/livenessprobe.rb).

```ruby
# method call

describe livenessprobe(container['livenessProbe']) do
  its('check') { should cmp true }
end
```

## parameters

The `parameters` control checks whether the template contains the required parameters and whether the parameters meet the requirements.

```yaml
parameters:
  - name: PROJECT # name can not be empty
    description: "Name of this project" # description can not be empty
```

### Checking the required parameters

In order to check whether the template contains the required parameter, you must add the first name of the parameter to the list in the file [`controls/parameters.rb`](controls/parameters.rb).

```ruby
# controls/parameters.rb

  required_parameters = [
    'PROJECT',
  ]
```

In the above example, we require the template to contain a parameter `PROJECT`.

### Library

To check whether the required parameter is included in the template, the `required_parameters` method is used which is in the `ParametersTemplate` class. The class is defined in the file [`libraries/parameters.rb`](libraries/parameters.rb)

```ruby
# method call

# method parameters as the first argument accepts template parameters
# second argument is an array with parameters that are required
describe parameters(template['parameters'], required_parameters) do
  its('required_parameters') { should cmp true }
end
```

## resources

The `resources` control checks whether the container has the resources it needs to run and limits.

```yaml
[...]
          resources:
            requests:
               memory: "0.5G" # can not be empty
               cpu: "0.2" # must be> = 0.1
            limits:
               memory: "0.5G" # can not be empty
[...]
```

## route

The `route` control checks if 'Route` meets the requirements. The control is only carried out when the resource is in the template.

```yaml
- apiVersion: v1 # must be 'v1'
  kind: Route
  metadata:
     labels:
       app: app_name
       area: area_name
       stack: stack_name
     name: app # name can not be empty
  spec:
     Harbor:
       targetPort: 8080-tcp # can not be empty
     tls:
       termination: edge # must be 'edge'
     to:
       kind: Service # must be 'Service'
       name: app_name # can not be empty
       weight: 100 # must be> 0
      wildcardPolicy: None
```

## service 

The `service` control checks whether `Service` meets the requirements. The control is only carried out when the resource is in the template.

```yaml
- apiVersion: v1 # must be v1
  kind: Service
  metadata:
     labels:
       app: app_name
       stack: stack_name
     name: app_name # can not be empty
  spec:
     ports:
     - name: 8080-tcp # can not be empty
       port: 8080 # can not be empty
       protocol: TCP # value must be / UDP | TCP /
       targetPort: 8080 # can not be empty
     selector: # selector must be defined
       app: app_name
       deploymentconfig: app_name
       stack: stack_name
     sessionAffinity: None
     type: ClusterIP # value must satisfy the condition / ClusterIP | LoadBalancer | NodePort | ExternalName /
```

## deploymentconfig

The `deploymentconfig` control checks whether `DeploymentConfig` meets the requirements.
