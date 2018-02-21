# Application template

The following repository contains the application template and the InSpec profile for testing the template.

## Application template and its testing

The template may vary significantly depending on the application, so the best method for testing the template is to check whether it contains elements that are required or desired.
For this purpose, the InSpec tool is used that allows testing of such an application template.

### Testing the template

The `app` directory contains the file [`template.yaml`](app/template.yaml) which can be treated as an output template for the application. In case you want to test our template, it must be located under the path `app/template.yaml`.

The [InSpec](https://www.inspec.io/downloads/) tool is also required for testing .

We run the tests by issuing the command `inspec exec profile` 

```bash
~# inspec exec profile

Profile: InSpec Profile (openshift_template)
Version: 0.1.0
Target:  local://

  ✔  health_check: Verify health checks
     ✔  livenessprobe check should cmp == true
     ✔  readinessprobe check should cmp == true
  ✔  resources: Verify whether container has had set resources
     ✔  {"requests"=>{"memory"=>"0.5G", "cpu"=>"0.2"}, "limits"=>{"memory"=>"0.5G"}} ["requests", "cpu"] should cmp >= 0.1

[...]

Profile Summary: 6 successful controls, 0 control failures, 0 controls skipped
Test Summary: 30 successful, 0 failures, 0 skipped
```

### What is checked during testing?

 Inspection name  | Description
-----------------|-----
 [`basic`](profile/controls/basic.rb) | tests whether the given file is actually a template for openshift
 [`health_check`](profile/controls/health_check.rb) | tests whether the application container contains `livenessProbe` and` readinessProbe`
 [`parameters`](profile/controls/parameters.rb) | tests whether the template contains the required parameters
 [`resources`](profile/controls/resources.rb) | tests whether the container has the resources set that are required by the applications
 [`route`](profile/controls/route.rb) | tests whether the `route` resource contains errors
 [`service`](profile/controls/service.rb) | tests whether the `service` resource contains errors

A detailed description of the InSpec profile can be found [here](profile/README.md).
