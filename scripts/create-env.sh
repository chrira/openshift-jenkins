#!/bin/sh


# configuration script for the OpenShift environment


oc new-project craaflaub-jenkins

oc process -f jenkins-ephemeral-template.json \
  | oc apply -f -


oc start-build gretl --from-dir . --follow

openshift/jenkins-slave-maven-centos7



############################


oc process -f jenkins-s2i-template.json \
  | oc apply -f -

#  -p DB_RESET_DATA=true \


oc create -f build.template
