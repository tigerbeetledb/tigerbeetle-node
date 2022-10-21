#!/usr/bin/env bash

set -e

./scripts/build.sh

# Prebuild the container with this directory because we have no need for its artifacts
id=$(docker build -q -f - . < <(echo "
FROM rockylinux:9
COPY . /wrk"))

docker run -w /test "$id" sh -c "
set -e
dnf update -y
dnf install -y xz wget git glibc
wget -O- -q https://rpm.nodesource.com/setup_16.x | bash -
dnf install -y nodejs
npm install /wrk
node -e 'require(\"tigerbeetle-node\");'
"
