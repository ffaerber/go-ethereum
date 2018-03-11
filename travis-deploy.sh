#!/bin/bash
set -e

image="ffaerber/go-ethereum"

docker tag geth "$image:linux-$ARCH-$TRAVIS_TAG"
docker push "$image:linux-$ARCH-$TRAVIS_TAG"

if [ "$ARCH" == "amd64" ]; then
  echo "Downloading manifest-tool"
  wget https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-amd64
  mv manifest-tool-linux-amd64 manifest-tool
  chmod +x manifest-tool
  ./manifest-tool

  echo "Pushing manifest $image:$TRAVIS_TAG"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64 \
    --template "$image:OS-ARCH-$TRAVIS_TAG" \
    --target "$image:$TRAVIS_TAG"

  echo "Pushing manifest $image:latest"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64 \
    --template "$image:OS-ARCH-$TRAVIS_TAG" \
    --target "$image:latest"
fi
