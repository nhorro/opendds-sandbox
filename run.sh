#!/bin/bash
docker run --rm -it \
  --name opendds-dev \
  -v "$(pwd)/workspace:/workspace" \
  --workdir /workspace \
  ubuntu20.04-opendds \
  bash