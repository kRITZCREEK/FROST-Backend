#!/bin/bash

#CLEAN
rm -rf ./static/
mkdir ./static/
touch ./static/.gitkeep

#BUILD FRONTEND
pushd ../reactive-psc/

./build.sh

popd

#COPY FRONTEND
cp -r ../reactive-psc/build/* ./static/

#BUILD BACKEND
export PORT=8000
#cabal test SO BALD WIE MOEGLICH!
cabal run
