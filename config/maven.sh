
#linter plugin ktlint:
  #see:
    mvn antrun:run@ktlint
  #apply:
    mvn antrun:run@ktlint-format

#Upload file to nexus:
  mvn deploy:deploy-file \
    -DgeneratePom=false \
    -DgroupId=project \
    -DartifactId=example \
    -Dversion=1.0 \
    -Dpackaging=tar.gz \
    -DrepositoryId=repo \
    -Durl=https://example.com/repository/ \
    -Dfile=example.tar.gz

#Passwords for repos:
  ~/.m2/settings.xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
      <servers>
        <server>
          <id>intra.net</id>
          <username>${env.REPO_USR}</username>
          <password>${env.REPO_PWD}</password>
        </server>
      <servers>
    </settings>

#Set up master password:
  mvn --encrypt-master-password
  #enter when prompted
  #copy into ~/.m2/settings-security.xml:
    <settingsSecurity>
      <master>{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}</master>
    </settingsSecurity>

#See dependency tree:
  mvn dependency:tree -Dverbose
  mvn dependency:tree -Dverbose -Dincludes=:spring*::

