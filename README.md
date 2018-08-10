openshift-jenkins
=================

This repo is used to do a source-to-image build on OpenShift.

The resulting Docker Image is a pre-configured Jenkins instance that will run inside OpenShift.
The configuration is located inside this repo.

The resulting Docker Image is a Jenkins that runs [gretljobs](https://github.com/sogis/gretljobs).
Those specific Jenkins Jobs will start a special Jenkins slave, the [Gretl Runtime](https://github.com/sogis/gretl).

Setup
-----
All OpenShift configuration and instruction is located inside the [gretl](https://github.com/sogis/gretl) repo at:
*serviceConfig/README.md*

Content
-------
The repo is structured to be used inside an OpenShift s2i build for Jenkins:
https://docs.okd.io/latest/using_images/other_images/jenkins.html

* the [configuration](configuration) folder contains the Jenkins Gretl specific Jenkins configuration.
  * this is in particular a Jenkins seeder job that generates other jobs, more informations below
* the [plugins.txt](plugins.txt) defines the Jenkins plugins to be installed and their versions.
  * actual plugin list of Jenkins ver. 2.89.2

More information on the needed repository layout:
https://docs.okd.io/latest/using_images/other_images/jenkins.html#jenkins-as-s2i-builder


### Seeder Job
configuration/jobs/administration/jobs/gretl-job-generator/config.xml

Creates Jenkins jobs from GRETL jobs using job DSL.

documentation links
* https://github.com/jenkinsci/job-dsl-plugin/wiki
* https://github.com/sheehan/job-dsl-gradle-example
* https://jenkinsci.github.io/job-dsl-plugin/

### Export plugin list
To export the installed plugins, use the User ID and API Token from the Jenkins user:
* Login into Jenkins
* select configure on your user name
* click on show API Token

```
JENKINS_HOST=username:password@myhost.com:port
curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/' > plugins.txt
```

Extract from [doc](https://github.com/jenkinsci/docker#preinstalling-plugins)


Jenkins OpenShift documentation
-------------------------------

https://github.com/openshift/jenkins

https://github.com/openshift/origin/blob/master/examples/jenkins/README.md

OpenShift template from origin examples:
* https://github.com/openshift/origin/blob/master/examples/jenkins/jenkins-ephemeral-template.json


misc
----

### Alternatives

Inject job as build config:

https://github.com/appuio/simple-openshift-pipeline-example

https://ose3-master.puzzle.ch:8443/console/project/tp-springboot-test/overview

### OpenShift

#### Service account
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
