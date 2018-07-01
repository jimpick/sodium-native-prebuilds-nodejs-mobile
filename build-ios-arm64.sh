#! /bin/bash

set -e

topDir=`cd $(dirname $0); pwd`
NODEJS_HEADERS_DIR=$topDir/node_modules/nodejs-mobile-react-native/ios/libnode
NODEJS_MOBILE_GYP_BIN_FILE=$topDir/node_modules/nodejs-mobile-gyp/bin/node-gyp.js

export GYP_DEFINES="OS=ios"
export npm_config_nodedir="$NODEJS_HEADERS_DIR"
export npm_config_node_gyp="$NODEJS_MOBILE_GYP_BIN_FILE"
export npm_config_platform="ios"
export npm_config_node_engine="chakracore"
export npm_config_arch="arm64"
export PREBUILD_ARCH=arm64
export PREBUILD_PLATFORM=ios
export PREBUILD_NODE_GYP="$NODEJS_MOBILE_GYP_BIN_FILE"

if [ ! -d sodium-native ]; then
  #git clone git@github.com:sodium-friends/sodium-native.git
  git clone git@github.com:jimpick/sodium-native.git
fi

pushd sodium-native

git checkout ios-prebuild

SODIUM_NATIVE=1 npm install

rm -rf libsodium
npm run fetch-libsodium

npx prebuildify \
  --strip \
  --preinstall "node preinstall.js" \
  --postinstall "node postinstall.js" \
  --platform=ios --arch=arm64 \
  --target=node@8.0.0

popd

tar cf - -C sodium-native prebuilds | tar xvf -
