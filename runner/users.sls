---
# ENSURE DOCKER GROUP EXISTS
# This group should have been created by the Docker states but we ensure it exists here anyway.  Users in this group
# have access to Docker so a subsequent states will ensure the gitlab-runner user is in this group.
docker_group:
  group.present:
    - name: docker

# ADD DYLAN TO DOCKER GROUP
# Ensure dylan user exists.  Add the dylan user to the docker group.  This user is created by the core states but they
# won't be run in testing.  Create the dylan user if necessary and add them to the docker group.
dylan_docker_group:
  user.present:
    - name: dylan
    - groups:
      - docker
    - require:
      - group: docker_group
