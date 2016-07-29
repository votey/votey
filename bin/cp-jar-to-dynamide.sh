#!/bin/bash

pushd `dirname $0`/.. > /dev/null

cp target/anarchia-mongodb-java.jar  ~/src/dynamide/lib/web.anarchia.us-1.0-SNAPSHOT.jar
cp target/anarchia-mongodb-java.jar  ~/src/dynamide/build/tomcat/webapps/ROOT/WEB-INF/lib/web.anarchia.us-1.0-SNAPSHOT.jar
popd