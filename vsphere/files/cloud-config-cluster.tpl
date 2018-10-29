#cloud-config
hostname: ${hostname}
ssh_authorized_keys:
  - ${authorized_key}
rancher:
  docker:
    engine: docker-${docker_version}
