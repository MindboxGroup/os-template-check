# Requirements, tips and tricks for OpenShift projects

This document contains information which should help during create a project for Openshift and requirements which should be fulfilled.

# Containers definition

This section is related to containers which are created by means of Dockerfile.

Dockerfile **has to** contain following requirements:

- The **`EXPOSE`** instruction has to expose all ports on which application listen on.

Dockerfile **should** contain following guidelines:

 - The **`USER`** instruction which defines other users than root.

**Caveats**
*Such container is not going to run correctly. Only in special cases, there is an ability to run container as root but it requires explicit indication in the project definition.*

# Pods

This section describes good practices during pods definition.

## General

* Don't use naked Pods. Naked Pods will not be rescheduled in the event of a node failure, in order to avoid such situation you should use `DeploymentConfig` resource. 

## Health Checks

* Every container in Pod should contain `livenessProbe` check. In cases where our container requires more time to be ready or we don't want to avoid a case where our application receive traffic for which is not ready to handle, then we should use `readinessProbe` check.

## Resources

* Every container in Pod should have defined resources which are required to right work. In addition to request resources, limits should be defined as well (memory limit at least)

## Logging

* Application in a container should be logging all messages directly to stdout.
* If it possible, an application should be logging termination reason to `termination-log`. More information you can find [here](https://kubernetes.io/docs/tasks/debug-application-cluster/determine-reason-pod-failure/#writing-and-reading-a-termination-message).

## Services

* Communication between containers should be conducted through services. It is not reasonable to use IP address for communication to an application which is running in a container.

## Container Images 

* You should avoid using the **`:latest`** tag when deploying containers in production, because this makes it hard to track which version of the image is running and hard to roll back.
* To make sure the container always uses the same version of the image, you can specify its digest (for example `sha256:46b35ftt08af5e43a7fea6c4cf9c25ccf269ee113168c19722f878345d3kew23`). This uniquely identifies a specific version of the image, so it will never be updated by Kubernetes unless you change the digest value.

## Additional privileges

* It is important to **never** change `default` service account (*ServiceAccount*). The default service account should have granted default privileges which not allow for access to API, such account also should have default SCC.

## Running container as root

If a container has to be running with root privileges we should keep following guidelines:
- You should create a dedicated service account (e.g. mysa) for your application/container and define to use this service account in Pod definition
- Grant proper privileges to your new ServiceAccount, e.g. `oc adm policy add-scc-to-user anyuid -n PROJECT_NAME -z mysa`
