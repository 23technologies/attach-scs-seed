# SCS attach Seed

This repo sets up a kubernetes cluster on the specified cloud and attaches it as seed to the specified gardener.

Demo: https://asciinema.org/a/417622

## Required software

* Terraform must be installed (https://learn.hashicorp.com/tutorials/terraform/install-cli)
* ``terraform/clouds.yaml`` and ``terraform/secure.yaml`` files must be created
  (https://docs.openstack.org/python-openstackclient/latest/configuration/index.html#clouds-yaml)
* ospurge is required for project-cleanup (be careful):
``python3 -m pip install git+https://git.openstack.org/openstack/ospurge``
* A gardener installation is required
* The gardener installation needs to have a controllerregistration for the openstack provider. In case
it does not have it yet, it can be easily added:
```kubectl apply -f https://raw.githubusercontent.com/gardener/gardener-extension-provider-openstack/master/example/controller-registration.yaml --kubeconfig gardener-apiserver.yaml```
* The gardener installation needs to have a controllerregistration for the ubuntu operating system. In case
it does not have it yet, it can be easily added:
```kubectl apply -f https://raw.githubusercontent.com/gardener/gardener-extension-os-ubuntu/master/example/controller-registration.yaml --kubeconfig gardener-apiserver.yaml```

## Configuration
All relevant steps happen in the folder terraform

Copy ``secure.yaml.sample`` to ``secure.yaml`` and ``clouds.yaml.sample`` to ``clouds.yaml``
and fill in the correct credentials for your openstack-cloud.

Adjust variables in environment/standard.tfvars to suit your needs.

Add the gardener-apiserver.yaml kubeconfig to the terraform/ folder.
This kubeconfig should access the virtual-gardener-apiserver in your garden-cluster

## Build up Gardener

**make sure that no other testbed is already in the project.**

``make create`` creates the testbed:

1. creates all relevant openstack resources, networks, securitygroups, dns-zones, VMs
2. creates kubernetes cluster with Cluster-API on the VMs
3. attaches this cluster as seed to the garden-cluster

## Teardown Gardener
#### Nice and slow
* Delete all Clusters inside gardener (via the dashboard or the API)
* ``make `` and ``sow burndown -A`` in folder ``landscape``
* ``make clean``
#### quick and rough
``make purge``

