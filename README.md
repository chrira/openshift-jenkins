openshift-jenkins
=================

Run Jenkins on OpenShift which starts Docker build-container in the same namespace.

Content
-------
OpenShift template and Jenkins configuration.

Jenkins
-------

OpenShift template from origin examples:

https://github.com/openshift/origin/blob/master/examples/jenkins/jenkins-ephemeral-template.json


Alternatives
------------

Inject job as build config:

https://github.com/appuio/simple-openshift-pipeline-example

https://ose3-master.puzzle.ch:8443/console/project/tp-springboot-test/overview

OpenShift
---------

### Service account
For build and deployment Jenkins must be able to log in with the oc tool.<br/>
This is done by a service account that must be added after the project is created.
The token of the secret of the service account must be added to jenkins as credential.
This token will be used from the deploy script.

* Login to the server with the oc tool and go to your project.
* *oc project* to check that you are in the right project.
* Add service account by this script: **scripts/create-service-account.sh**
* Read the token:
 * *oc describe sa jenkins*
 * Copy name of first Token.
 * *oc describe secret JENKINS-TOKEN-NAME*
 * this will display the token
* Create a secret text credential on jenkins
 * ID must be like this: **OPENSHIFT_PROJECT_NAME_deploy_token**
