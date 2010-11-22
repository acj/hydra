#!/usr/bin/env bash

if [ -d "build" ]; then
	cd build
	jar -cfe ../hydra.jar MainDriver h2PFoundation h2PVisitors xmi2hil h2PNodes META-INF promelaParser umlModel xmiParser MainDriver.class
	cd ..
	exit 0;
else
	echo "Please build Hydra using Eclipse first."
	exit 1;
fi