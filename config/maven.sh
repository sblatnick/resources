
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

#Override sub-dependency example for pom.xml:
  <dependency>
    <groupId>com.jayway.jsonpath</groupId>
    <artifactId>json-path</artifactId>
    <version>2.9.0</version>
    <exclusion>
        <groupId>net.minidev</groupId>
        <artifactId>json-smart</artifactId>
    </exclusion>
  </dependency>
  <dependency>
    <groupId>net.minidev</groupId>
    <artifactId>json-smart</artifactId>
    <version>[2.5.2,)</version>
  </dependency>

#Skipping plugins
  -dpluginName.skip=true
  #For plugins that do not support skip, there is a hacky way to skip without the use of profiles
  #source: https://stackoverflow.com/questions/15767132/how-do-i-skip-a-maven-plugin-execution-if-dskiptests-or-dmaven-test-skip-tr
    <properties>
       <property>
          <pluginxyz.skip><pluginxyz.skip>
       </property>
    </properties>
    ...
    <plugin>
        <groupId>org.xyz</groupId>
        <artifactId>xyz-maven-plugin</artifactId>
        <version>2.0.1</version>
        <executions>
          <execution>
            <id>build-database</id>
            <phase>process-test-classes${pluginxyz.skip}</phase>
            <configuration>....</configuration>
         </execution>
    <plugin>

  #Then when executing from the command line you can add -Dpluginxyz.skip=true which will append the true value to the phase name.
  #Since there is no phase called process-test-classestrue the goal will not be executed.
  #Note: -Dpluginxyz.skip=false would also skip

