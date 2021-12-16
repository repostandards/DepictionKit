#!/bin/sh

jazzy --build-tool-arguments -scheme,DepictionKit,-target,DepictionKit
cp img/* docs/img/
