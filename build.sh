#!/bin/bash
set -xe

bin_path=$(swift build --configuration release --show-bin-path --arch arm64 --arch x86_64)
swift build --configuration release --arch arm64 --arch x86_64

mkdir -p build dist

cp alfred/* build/
cp "${bin_path}/systemaudio" build/
cp "${bin_path}/systemaudio" dist/

cd build
zip -r ../dist/systemaudio.alfredworkflow *