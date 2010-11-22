#!/usr/bin/env bash

for j in `ls *.jj`; do javacc $j; done