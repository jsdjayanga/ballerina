#!/bin/bash

#BALLERINA_VERSION=0.970.0-alpha1-SNAPSHOT
BALLERINA_VERSION=0.970.0-alpha4
#BALZIP=../../distribution/zip/ballerina-tools/target/ballerina-tools-$BALLERINA_VERSION.zip
#BALZIP=/Users/jayanga/Documents/temp/bal/ballerina-tools-$BALLERINA_VERSION.zip
#BALZIP=/Users/jayanga/Documents/Ballerina-07APR2018/ballerina-tools-mac-$BALLERINA_VERSION.zip
BALZIP=/Users/jayanga/Documents/Ballerina-11APR2018/ballerina-platform-macos-0.970.0-alpha4.zip
BALDIST=ballerina-platform-macos-$BALLERINA_VERSION

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

echo "/Library/Ballerina/ballerina-$BALLERINA_VERSION/bin" >> target/darwinpkg/etc/paths.d/ballerina
chmod -R 644 target/darwinpkg/etc/paths.d/ballerina

mkdir -p target/darwinpkg/Library/Ballerina
chmod -R 755 target/darwinpkg/Library/Ballerina

mv target/$BALDIST target/darwinpkg/Library/Ballerina/ballerina-$BALLERINA_VERSION

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
target/pkg/ballerina-platform-macos-installer-x64-$BALLERINA_VERSION.pkg > /dev/null 2>&1

#mkdir -p target/pkg-signed
#chmod -R 755 target/pkg-signed

#productsign --sign "Developer ID Installer: WSO2, Inc. (QH8DVR4443)" \
#target/pkg/$BALDIST-macosx-x64.pkg \
#target/pkg-signed/$BALDIST-macosx-x64.pkg

#pkgutil --check-signature target/pkg-signed/$BALDIST-macosx-x64.pkg

echo $BALDIST "build completed at" $(date +"%Y-%m-%d %H:%M:%S")

