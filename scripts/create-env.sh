#!/bin/sh

# configuration script for the OpenShift environment
#oc new-project craaflaub-jenkins

oc process -f jenkins-s2i-template.json \
  -p JENKINS_CONFIGURATION_REPO_URL="https://github.com/chrira/openshift-jenkins.git" \
  -p GRETL_JOB_REPO_URL="git://github.com/chrira/gretljobs.git" \
  | oc apply -f -

# oc start-build gretl --from-dir . --follow
# openshift/jenkins-slave-maven-centos7
