# Vagrant Quickstart

This folder contains Vagrant code to stand up a single Rancher server instance with a single node cluster attached to it.

## Requirements

- [Vagrant](https://www.vagrantup.com)
- [VirtualBox](https://www.virtualbox.org)
- 6GB unused RAM

## Deploy

0. Clone this repository and go into the vagrant subfolder
0. Run `vagrant up`

When provisioning is finished the Rancher UI will become accessible on [192.168.56.101](http://192.168.56.101).
The default password is `adminPassword`, but this can be updated in the config.yaml file (must be at least 12 characters).

If you want to enable open-iscsi (to enable longhorn) you can set `node.open-iscsi: enabled` in config.yaml or local_config.yaml.

If you want to keep the configuration changes outside the git repository you can copy the config.yaml file to local_config.yaml and make changes there.

## Remove

To remove the VMs that have been deployed run `vagrant destroy -f`
