---
# ENSURE DOCKER GROUP EXISTS
# This group should have been created by the Docker states but we ensure it exists here anyway.  Users in this group
# have access to Docker so a subsequent states will ensure the gitlab-runner user is in this group.
docker_group:
  group.present:
    - name: docker

# CREATE DYLAN USER
# Ensure dylan user exists.  This is a personal user account on the machine used for maintenance and diagnostics
# although it is becoming less necessary with Salt.
dylan_user:
  user.present:
    - name: dylan
    - groups:
      - sudo
      - docker
    - requires:
      - group: docker_group

# CREATE RUNNER USER
# Ensure gitlab-runner user exists.  This is the user that build jobs run as so we ensure it is in the docker group and
# therefore has access to Docker.  This user should have been created when installing the gitlab-runner package.
runner_user:
  user.present:
    - name: gitlab-runner
    - groups:
      - docker
    - requires:
      - group: docker_group
      - pkg: runner_packages

# COMMENT BASH LOGOUT SCRIPT
# The default .bash_logout script in Ubuntu causes problems and causes GitLab CI/CD jobs to fail.  Therefore, we need
# to comment out this file.  We use the regex to match everything to ensure everything is commented.
runner_bash_logout:
  file.comment:
    - name: /home/gitlab-runner/.bash_logout
    - regex: ^(.*)$
