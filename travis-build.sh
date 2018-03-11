#!/bin/bash
set -e

if [ "$ARCH" != "amd64" ]; then
  # prepare qemu
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
  docker create --name qemu-register hypriot/qemu-register
  if [ "$ARCH" == "arm7" ]; then
    docker cp qemu-register:qemu-arm qemu-arm-static
  fi
  if [ "$ARCH" == "arm64" ]; then
    docker cp qemu-register:qemu-aarch64 qemu-aarch64-static
  fi
fi

if [ "$ARCH" == "amd64" ]; then
  touch "$QEMU"  # HACK to fake a qemu-amd64-static
fi

wget https://gethstore.blob.core.windows.net/builds/$GETH_SOURCE.tar.gz
tar -xvf ./$GETH_SOURCE.tar.gz
mv ./$GETH_SOURCE go-ethereum

if [ -d tmp ]; then
  docker rm build
  rm -rf tmp
fi

docker build -t go-ethereum \
  --build-arg BASE_IMAGE=$BASE_IMAGE \
  --build-arg QEMU=$QEMU \
  .
