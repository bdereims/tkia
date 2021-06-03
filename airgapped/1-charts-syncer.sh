#!/bin/bash
#bdereims@vmware.com

git clone https://github.com/bitnami-labs/charts-syncer.git

mkdir dist
curl -Lo dist/charts-syncer.tar.gz https://github.com/bitnami-labs/charts-syncer/releases/download/v0.9.0/charts-syncer_0.9.0_linux_x86_64.tar.gz
tar xzf dist/charts-syncer.tar.gz -C dist
