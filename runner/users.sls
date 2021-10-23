---
# ADD DYLAN TO DOCKER GROUP
# Ensure dylan user exists.  This user is created by the core states but they won't be run in testing.  Create the dylan
# user if necessary and add them to the docker group.  This group should have been created by the Docker states but we
# ensure it exists here anyway.  Users in this group have access to Docker.
dylan_docker_group:
  user.present:
    - name: dylan
  group.present:
    - name: docker
    - addusers:
      - dylan
    - require:
      - user: dylan_docker_group
