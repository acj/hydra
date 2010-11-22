#!/usr/bin/env bash

if [ -d "build" ]; then
	cd build
	jar -cf hydra.jar h2PFoundation h2PVisitors xmi2hil h2PNodes META-INF promelaParser umlModel xmiParser
	cd ..
	exit 0;
else
	echo "Please build Hydra using Eclipse first."
	exit 1;
fi