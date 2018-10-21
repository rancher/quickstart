# Quickstart examples for Rancher

## Summary

This repo contains scripts that will allow you to quickly deploy and test Rancher for POC.
The contents aren't intended for production but are here to get you up and going with running Rancher Server for a POC and to help show the functionality

## DO quick start

The DO folder contains terraform code to stand up a single Rancher server instance with a 3 node cluster attached to it.

This terraform setup will:

- Start a droplet running `rancher/rancher` version specified in `rancher_version`
- Create a custom cluster called `cluster_name`
- Start `count_agent_all_nodes` amount of droplets and add them to the custom cluster with all roles

### How to use

- Clone this repository and go into the DO subfolder
- Move the file `terraform.tfvars.example` to `terraform.tfvars` and edit (see inline explanation)
- Run `terraform init`
- Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server

### How to Remove

To remove the VM's that have been deployed run `terraform destroy --force`

### Optional adding nodes per role
- Start `count_agent_etcd_nodes` amount of droplets and add them to the custom cluster with etcd role
- Start `count_agent_controlplane_nodes` amount of droplets and add them to the custom cluster with controlplane role
- Start `count_agent_worker_nodes` amount of droplets and add them to the custom cluster with worker role

**Please be aware that you will be responsible for the usage charges with Digital Ocean**

## Scaleway quick start

The Scaleway folder contains terraform code to stand up a single Rancher server instance with a 3 node cluster attached to it.

### How to Use

The instructions are basically the same as [DO](#do-quick-start).

The following are specific to Scaleway:

- `scw_token` in the `terraform.tfvars` can be created in the `Account > Credentials > Tokens` section.
- `scw_org` in the `terraform.tfvars` can be found in the `Account > ORGANIZATION ID` section.


**Please be aware that you will be responsible for the usage charges with Digital Ocean**

## Vagrant quick start

The vagrant folder contains a vagrant code to stand up a single Rancher server instance with a 3 node cluster attached to it.

The pre-requistes for this are [vagrant](https://www.vagrantup.com) and [virtualbox](https://www.virtualbox.org), installed on the PC you intend to run it on, and 6GB free memory

### How to Use

- Clone this repository and go into the vagrant subfolder
- Run `vagrant up`

When provisioning is finished the Rancher UI will become accessible on http://172.22.101.101 the default password is `admin`, but this can be updated in the config.yaml file.

### How to Remove

To remove the VM's that have been deployed run `vagrant destroy -f`

## Amazon AWS Quick Start

The aws folder contains terraform code to stand up a single Rancher server instance with a 1 node cluster attached to it.

You will need the following:

- An AWS Account with an access key and secret key
- The name of a pre-created AWS Key Pair
- Your desired AWS Deployment Region

This terraform setup will:

- Start an Amazon AWS EC2 instance running `rancher/rancher` version specified in `rancher_version`
- Create a custom cluster called `cluster_name`
- Start `count_agent_all_nodes` amount of AWS EC2 instances and add them to the custom cluster with all roles

### How to use

- Clone this repository and go into the aws subfolder
- Move the file `terraform.tfvars.example` to `terraform.tfvars` and edit (see inline explanation)
- Run `terraform init`
- Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server

### How to Remove

To remove the VM's that have been deployed run `terraform destroy --force`

### Optional adding nodes per role
- Start `count_agent_all_nodes` amount of AWS EC2 Instances and add them to the custom cluster with all role
- Start `count_agent_etcd_nodes` amount of AWS EC2 Instances and add them to the custom cluster with etcd role
- Start `count_agent_controlplane_nodes` amount of AWS EC2 Instances and add them to the custom cluster with controlplane role
- Start `count_agent_worker_nodes` amount of AWS EC2 Instances and add them to the custom cluster with worker role

**Please be aware that you will be responsible for the usage charges with Amazon AWS**
