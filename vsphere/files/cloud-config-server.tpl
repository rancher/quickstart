#cloud-config
hostname: ${hostname}
ssh_authorized_keys:
  - ${authorized_key}
rancher:
  docker:
    engine: docker-${docker_version}
  services:
    rancher-qs-server:
      image: rancher/rancher:${rancher_version}
      restart: unless-stopped
      privileged: false
      ports:
        - 80:80
        - 443:443
      volumes:
        - /root/rancher:/var/lib/rancher 
