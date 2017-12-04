#!/bin/sh

# configuration script for the OpenShift environment

oc process -f jenkins-ephemeral-template.json \
  | oc create -f -


#  -p DB_RESET_DATA=true \
