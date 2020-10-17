# Quickstart examples for Rancher

Quickly stand up an HA-style Rancher management server in your infrastructure provider of choice.

Intended for experimentation/evaluation ONLY.

**You will be responsible for any and all infrastructure costs incurred by these resources.**
As a result, this repository minimizes costs by standing up the minimum required resources for a given provider.
Use Vagrant to run Rancher locally and avoid cloud costs.

## Local quickstart

A local quickstart is provided in the form of Vagrant configuration.

**The Vagrant quickstart does not currently follow Rancher best practices for installing a Rancher management server.**
Use this configuration only to evaluate the features of Rancher.
See cloud provider quickstarts for an HA foundation according to Rancher installation best practices.

### Requirements - Vagrant (local)

- [Vagrant](https://www.vagrantup.com)
- [VirtualBox](https://www.virtualbox.org)
- 6GB unused RAM

### Using Vagrant quickstart

See [/vagrant](./vagrant) for details on usage and settings.


## Cloud quickstart

Quickstarts are provided for [**Amazon Web Services** (`aws`)](./aws), [**Microsoft Azure Cloud** (`azure`)](./azure), [**Microsoft Azure Cloud with Windows nodes** (`azure-windows`)](./azure-windows), [**DigitalOcean** (`do`)](./do), and [**Google Cloud Platform** (`gcp`)](./gcp).

**You will be responsible for any and all infrastructure costs incurred by these resources.**

Each quickstart will install Rancher on a single-node RKE cluster, then will provision another single-node workload cluster using a Custom cluster in Rancher.
This setup provides easy access to the core Rancher functionality while establishing a foundation that can be easily expanded to a full HA Rancher server.

### Requirements - Cloud

- Terraform >=0.13.0
- Credentials for the cloud provider used for the quickstart

### Deploy

To begin with any quickstart, perform the following steps:

1. Clone or download this repository to a local folder
1. Choose a cloud provider and navigate into the provider's folder
1. Copy or rename `terraform.tfvars.example` to `terraform.tfvars` and fill in all required variables
1. Run `terraform init`
1. Run `terraform apply`

When provisioning has finished, terraform will output the URL to connect to the Rancher server.
Two sets of Kubernetes configurations will also be generated:
- `kube_config_server.yaml` contains credentials to access the RKE cluster supporting the Rancher server
- `kube_config_workload.yaml` contains credentials to access the provisioned workload cluster

For more details on each cloud provider, refer to the documentation in their respective folders.

### Remove

When you're finished exploring the Rancher server, use terraform to tear down all resources in the quickstart.

**NOTE: Any resources not provisioned by the quickstart are not guaranteed to be destroyed when tearing down the quickstart.**
Make sure you tear down any resources you provisioned manually before running the destroy command.

Run `terraform destroy -auto-approve` to remove all resources without prompting for confirmation.
