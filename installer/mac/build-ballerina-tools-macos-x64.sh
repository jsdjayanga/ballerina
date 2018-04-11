#!/bin/bash

BALLERINA_VERSION=0.970.0-alpha1-SNAPSHOT
#BALZIP=../../distribution/zip/ballerina-tools/target/ballerina-tools-$BALLERINA_VERSION.zip
BALZIP=/Users/jayanga/Documents/temp/bal/ballerina-tools-$BALLERINA_VERSION.zip
BALDIST=ballerina-tools-$BALLERINA_VERSION

rm -rf target
unzip $BALZIP -d target > /dev/null 2>&1

cp -r darwin target/darwin

sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/darwin/scripts/postinstall
chmod -R 755 target/darwin/scripts/postinstall

sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/darwin/Distribution
chmod -R 755 target/darwin/Distribution

mkdir -p target/darwinpkg
chmod -R 755 target/darwinpkg

mkdir -p target/darwinpkg/etc/paths.d
chmod -R 755 target/darwinpkg/etc/paths.d

echo "/usr/local/ballerina/ballerina-$BALLERINA_VERSION/bin" >> target/darwinpkg/etc/paths.d/ballerina
chmod -R 644 target/darwinpkg/etc/paths.d/ballerina

mkdir -p target/darwinpkg/usr/local/ballerina
chmod -R 755 target/darwinpkg/usr/local/ballerina

mv target/$BALDIST target/darwinpkg/usr/local/ballerina/ballerina-$BALLERINA_VERSION

mkdir -p target/package
chmod -R 755 target/package

mkdir -p target/pkg
chmod -R 755 target/pkg

echo $BALDIST "build started at" $(date +"%Y-%m-%d %H:%M:%S")

pkgbuild --identifier org.ballerina.$BALLERINA_VERSION \
--version $BALLERINA_VERSION \
--scripts target/darwin/scripts \
--root target/darwinpkg \
target/package/ballerina.pkg > /dev/null 2>&1

productbuild --distribution target/darwin/Distribution \
--resources target/darwin/Resources \
--package-path target/package \
target/pkg/$BALDIST-macosx-x64.pkg > /dev/null 2>&1

echo $BALDIST "build completed at" $(date +"%Y-%m-%d %H:%M:%S")

