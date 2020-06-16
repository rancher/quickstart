# Quickstart examples for Rancher

Quickly stand up an HA-style Rancher management server in your infrastructure provider of choice.

Intended for experimentation/evaluation ONLY.

**You will be responsible for any and all infrastructure costs incurred by these resources.**
As a result, this repository minimizes costs by standing up the minimum required resources for a given provider.
Use Vagrant to run Rancher locally and avoid cloud costs.

## Local quickstart

A local quickstart is provided in the form of Vagrant configuration.

**The Vagrant quickstart does not currently follow Rancher best practices for installing a Rancher manangement server.**
Use this configuration only to evaluate the features of Rancher.
See cloud provider quickstarts for an HA foundation according to Rancher installtion best practices.

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

- Terraform >=0.12.0
- RKE terraform provider version 1.0.0 installed locally - full install instructions [below](#installing-terraform-provider-rke)
- Credentials for the cloud provider used for the quickstart

#### Installing terraform-provider-rke

##### Linux

###### 64-bit

Download [the v1.0.0 release archive for Linux](https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-linux-amd64.tar.gz),
extract the archive, and move the binary in `terraform-provider-rke-9c95410` to
`~/.terraform.d/plugins/linux_amd64/terraform-provider-rke_v1.0.0`.

If curl and tar are installed, you can use the following script:
```sh
curl -LO https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-linux-amd64.tar.gz && \
tar -xzvf terraform-provider-rke-linux-amd64.tar.gz && \
chmod +x ./terraform-provider-rke-9c95410/terraform-provider-rke && \
mkdir -p ~/.terraform.d/plugins/linux_amd64/ && \
mv ./terraform-provider-rke-9c95410/terraform-provider-rke ~/.terraform.d/plugins/linux_amd64/terraform-provider-rke_v1.0.0
rm -rf ./terraform-provider-rke-*
```

##### MacOS

Download [the v1.0.0 release archive for MacOS](https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-darwin-amd64.tar.gz),
extract the archive, and move the binary in `terraform-provider-rke-9c95410` to
`~/.terraform.d/plugins/darwin_amd64/terraform-provider-rke_v1.0.0`.

If curl and tar are installed, you can use the following script:
```sh
curl -LO https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-darwin-amd64.tar.gz && \
tar -xzvf terraform-provider-rke-darwin-amd64.tar.gz && \
chmod +x ./terraform-provider-rke-9c95410/terraform-provider-rke && \
mkdir -p ~/.terraform.d/plugins/darwin_amd64/ && \
mv ./terraform-provider-rke-9c95410/terraform-provider-rke ~/.terraform.d/plugins/darwin_amd64/terraform-provider-rke_v1.0.0
rm -rf ./terraform-provider-rke-*
```

##### Windows

###### 64-bit

Download [the v1.0.0 release archive for Windows (64-bit)](https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-windows-amd64.zip),
extract the archive, and move the executable in `terraform-provider-rke-9c95410` to
`%APPDATA%\terraform.d\plugins\windows_amd64\terraform-provider-rke_v1.0.0.exe`.

You can use the following PowerShell script to perform the same steps (tested with PS version 5.1):
```
New-Item -Path $Env:APPDATA\terraform.d\plugins\windows_amd64 -ItemType Directory -Force
Invoke-WebRequest -Uri https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-windows-amd64.zip -OutFile terraform-provider-rke-windows-amd64.zip -UseBasicParsing
Expand-Archive terraform-provider-rke-windows-amd64.zip
Move-Item -Path terraform-provider-rke-windows-amd64\terraform-provider-rke-9c95410\terraform-provider-rke.exe -Destination $Env:APPDATA\terraform.d\plugins\windows_amd64\terraform-provider-rke_v1.0.0.exe
Remove-Item -Path terraform-provider-rke-windows-amd64* -Recurse
```

###### 32-bit

Download [the v1.0.0 release archive for Windows (32-bit)](https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-windows-386.zip),
extract the archive, and move the executable in `terraform-provider-rke-9c95410` to
`%APPDATA%\terraform.d\plugins\windows_386\terraform-provider-rke_v1.0.0.exe`.

You can use the following PowerShell script to perform the same steps (tested with PS version 5.1):
```
Invoke-WebRequest -Uri https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-windows-386.zip -OutFile terraform-provider-rke-windows-386.zip -UseBasicParsing
New-Item -Path $Env:APPDATA\terraform.d\plugins\windows_386 -ItemType Directory -Force
Expand-Archive terraform-provider-rke-windows-386.zip
Move-Item -Path terraform-provider-rke-windows-386\terraform-provider-rke-9c95410\terraform-provider-rke.exe -Destination $Env:APPDATA\terraform.d\plugins\windows_386\terraform-provider-rke_v1.0.0.exe
Remove-Item -Path terraform-provider-rke-windows-386* -Recurse
```

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
