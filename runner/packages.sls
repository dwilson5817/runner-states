---
# ADD RUNNER REPO
# Run the gitlab-runner install script which will check the current operating system version and add the repo for that
# version accordingly.  If the runner_gitlab-runner.list file exists, this state won't be run.
runner_repo:
  cmd.script:
    - name: https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh
    - creates:
        - /etc/apt/sources.list.d/runner_gitlab-runner.list

# INSTALL RUNNER PACKAGES
# Install Java, Maven and finally the gitlab-runner package itself.  Java and Maven are not required by gitlab-runner,
# they are used for compiling Java programs.  It would be wise to migrate build jobs that run natively into a Docker
# container in future.
runner_packages:
  pkg.installed:
    - pkgs:
      - default-jdk
      - maven
      - gitlab-runner
    - requires:
      - cmd: runner_repo

# INSTALL RUBY DEPENDENCIES
# There are some packages not installed on Ubuntu by default that need to be installed to run Ruby.  Ruby will then be
# installed using rbenv in the following state.
ruby_deps:
  pkg.installed:
    - names:
      - autoconf
      - bison
      - build-essential
      - libssl-dev
      - libyaml-dev
      - libreadline-dev
      - zlib1g-dev
      - libncurses5-dev
      - libffi-dev
      - libgdbm6
      - libgdbm-dev
      - libdb-dev

# INSTALL RUBY USING RBENV
# All Ruby dependencies have been installed.  Ruby will now be installed using rbenv, Ruby is required on build machines
# because it is used by Kitchen CI to test these states.
install_ruby:
  rbenv.installed:
    - name: ruby-2.7.2
    - default: True
    - user: gitlab-runner
    - require:
      - pkg: runner_packages
      - pkg: ruby_deps
