#!/bin/bash

# 1. Build Docker image
docker build -t ghcr.io/kuuhaku86/karsajobs-ui:latest .

# 2. Login to Docker Hub
echo $GITHUB_PAT | docker login ghcr.io -u kuuhaku86 --password-stdin

# 3. Push image to Docker Hub
docker push ghcr.io/kuuhaku86/karsajobs-ui:latest