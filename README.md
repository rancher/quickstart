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
- Create a custom cluster called `cluster_name`
- Start `count_agent_all_nodes` amount of VMs in vSphere and add them to the custom cluster with all roles

### Prerequisites

#### VMware vSphere

The terraform code was tested on vSphere 6.7 but should work with vSphere 6.0 and later.

#### VM Network

There must be VM network available in vSphere that provides:
- IP address assignment via DHCP
- Internet access to the public Docker registry (aka Docker Hub)

#### Ubuntu Cloud Image VM template

Before running the terraform code you must create a VM template in vSphere based off of the official Ubuntu 16.04 LTS cloud image. This is so that the VMs can be correctly bootstrapped using a Cloud-Init userdata script.

1. Log in to vCenter using the vSphere web console.
2. Right-click on the inventory list and select "Deploy OVF template...".
3. Specify the URL to the Ubuntu 16.04 LTS cloud image virtual appliance and hit *Next*: [ubuntu-16.04-server-cloudimg-amd64.ova](https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-amd64.ova)
4. Select an inventory folder to save the VM template in.
5. Select the cluster, host or resource pool in which to temporarily create the VM before converting it to a template.
6. Select a (preferably shared) datastore for the disk image.
7. Select the network to use for the template.
8. Skip the "Customize template" step.
9. Navigate to the newly created VM, click "Edit Settings..." in the context menu and update the size of "Hard disk 1" to 25GB or larger.
10. Finally convert the VM to a template by selecting "Convert to template..." in the context menu.

### How to use

1. Clone this repository and go into the `vsphere` subfolder.
2. Copy the file `terraform.tfvars.example` to `terraform.tfvars` and modify the later to match your environment (see inline comments in `variables.tf`).
3. At least specify the name/path of the Ubuntu template (`vsphere_template`) as well as the following configuration variables:
    - `vcenter_user`
    - `vcenter_password`
    - `vcenter_server`
    - `vsphere_datacenter`
    - One of `vsphere_resource_pool` or `vsphere_cluster`
    - `vsphere_datastore`
    - `vsphere_network`
4. Run `terraform init`
5. Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server. Log in with username `admin` and the password specified in the `rancher_admin_password` config variable.

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
