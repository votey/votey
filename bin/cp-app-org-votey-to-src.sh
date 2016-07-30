#!/bin/bash

pushd ${DYNAMIDE_HOME}/build/resource_root/homes/dynamide/assemblies/com-dynamide-apps-1/apps
cp -r org.votey/* ~/src/votey/src/apps/org.votey
cp -r org.votey/* ~/src/dynamide/src/assemblies/dynamide-apps/apps/org.votey

cp -r org.votey.registrar/* ~/src/votey/src/apps/org.votey.registrar
cp -r org.votey.registrar/* ~/src/dynamide/src/assemblies/dynamide-apps/apps/org.votey.registrar

popd


