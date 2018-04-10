#!/bin/bash

BALLERINA_VERSION=0.970.0-alpha1-SNAPSHOT
BALZIP=/home/ubuntu/Packs/ballerina-linux-$BALLERINA_VERSION.zip
BALDIST=ballerina-linux-$BALLERINA_VERSION

echo $BALDIST "build started at" $(date +"%Y-%m-%d %H:%M:%S")

rm -rf target
mkdir -p target/original
unzip $BALZIP -d target/original > /dev/null 2>&1
mv target/original/$BALDIST target/original/ballerina-linux-$BALLERINA_VERSION

mkdir -p target/$BALDIST/opt/ballerina
chmod -R 755 target/$BALDIST/opt/ballerina

mv target/original/ballerina-linux-$BALLERINA_VERSION target/$BALDIST/opt/ballerina 

cp -R linux/DEBIAN target/$BALDIST/DEBIAN
sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/DEBIAN/postinst
sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/DEBIAN/postrm
sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/DEBIAN/control

dpkg-deb --build target/$BALDIST

echo $BALDIST "build completed at" $(date +"%Y-%m-%d %H:%M:%S")



