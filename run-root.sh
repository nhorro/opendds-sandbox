#!/bin/bash
docker run -it --rm \
  --name opendds-dev \
  -v "$(pwd)/workspace:/workspace" \
  --workdir /workspace \
  ubuntu20.04-opendds \
  bash
