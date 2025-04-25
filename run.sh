#!/bin/bash
docker run -it --rm \
  --name opendds-dev \
  -v "$(pwd)/workspace:/workspace" \
  --workdir /workspace \
  --user $(id -u):$(id -g) \
  ubuntu20.04-opendds \
  bash
