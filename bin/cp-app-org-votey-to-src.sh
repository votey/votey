#!/bin/bash

pushd ${DYNAMIDE_HOME}/build/resource_root/homes/dynamide/assemblies/com-dynamide-apps-1/apps
cp -r org.votey/* ~/src/votey/src/apps/org.votey
cp -r org.votey/* ~/src/dynamide/src/assemblies/dynamide-apps/apps/org.votey

cp -r org.votey.admin/* ~/src/votey/src/apps/org.votey.admin
cp -r org.votey.admin/* ~/src/dynamide/src/assemblies/dynamide-apps/apps/org.votey.admin

popd


