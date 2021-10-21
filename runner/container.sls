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
