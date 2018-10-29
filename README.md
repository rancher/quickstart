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

## vSphere quick start

The vsphere folder contains terraform code to stand up a single Rancher server instance with a 3 node cluster attached to it.

This terraform setup will:

- Create a VM in vSphere running `rancher/rancher` version specified in `rancher_version`
- Create a custom cluster called `qs-cluster`
- Start `count_agent_all_nodes` amount of VMs in vSphere and add them to the custom cluster with all roles

### How to use

#### Create RancherOS template

The terraform setup creates VMs by cloning a RancherOS template that must be made available in vCenter:

1. Download the RancherOS OVA appliance from https://transfer.sh/FZfU3/rancheros-v1.4.0-vapp.ova
2. Import the OVA file by right-clicking on a cluster or host in the inventory and selecting "Deploy OVF template...".
3. Mark the resulting VM as template -> "Convert to template".
4. Note the name/path of the template.

#### Run the terraform code

1. Clone this repository and go into the `vsphere` subfolder
2. Move the file `terraform.tfvars.example` to `terraform.tfvars` and edit (see inline explanation)
3. Run `terraform init`
4. Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server.

### How to Remove

To remove the VM's that have been deployed run `terraform destroy --force`

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
