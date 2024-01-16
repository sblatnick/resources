#!/bin/bash

echo "Install groovy ${GROOVY_VERSION}"
cd /opt
curl \
  --insecure \
  --silent \
  --retry 3 \
  --location \
  --output "groovy.zip" \
  "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-${GROOVY_VERSION}.zip"
unzip groovy.zip
ln -s /opt/groovy-${GROOVY_VERSION}/ /opt/groovy
ln -s /opt/groovy/bin/groovy /usr/local/bin/groovy
rm groovy.zip

