---
# ENSURE RUNNER CONTAINER IS RUNNING
# GitLab Runner will be run from a Docker container.  If this is not already running we start is now.  It will be set to
# restart automatically.  The configuration for this container will be stored on a Docker volume called
# gitlab-runner-config.  This will still require manual registration the first time a runner is brought up.
runner_container:
  docker_container.running:
    - name: gitlab-runner
    - image: gitlab/gitlab-runner:latest
    - restart_policy: always
    - binds:
      - /var/run/docker.sock:/var/run/docker.sock
      - gitlab-runner-config:/etc/gitlab-runner

# ENSURE IPv6 NAT CONTAINER IS RUNNING
# NAT!  On IPv6?  Who hurt you?  Okay, this isn't a permanent solution but right now Docker IPv6 support is half-baked
# and it's difficult to use and I don't like that.  So for now, we essentially use a like for like IPv6 implementation
# of the way Docker networking works for IPv4.
#
# See more: https://github.com/robbertkl/docker-ipv6nat#why-would-i-need-this
ipv6nat_container:
  docker_container.running:
    - name: ipv6nat
    - image: robbertkl/ipv6nat
    - privileged: true
    - network_mode: host
    - restart_policy: unless-stopped
    - binds:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /lib/modules:/lib/modules:ro
