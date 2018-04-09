#!/bin/bash

BALLERINA_VERSION=0.970.0-alpha1-SNAPSHOT
BALZIP=/home/jayanga/Documents/Ballerina-07APR2018/ballerina-linux-$BALLERINA_VERSION.zip
BALDIST=ballerina-linux-$BALLERINA_VERSION

echo $BALDIST "build started at" $(date +"%Y-%m-%d %H:%M:%S")

rm -rf target
mkdir -p target/original
unzip $BALZIP -d target/original #> /dev/null 2>&1
mv target/original/$BALDIST target/original/ballerina-linux-$BALLERINA_VERSION

mkdir -p target/$BALDIST/opt/ballerina
chmod -R 755 target/$BALDIST/opt/ballerina

mv target/original/ballerina-linux-$BALLERINA_VERSION target/$BALDIST/opt/ballerina 

#mkdir -p target/$BALDIST/usr/bin
#chmod -R 755 target/$BALDIST/usr/bin

#mkdir -p target/$BALDIST/etc/profile.d
#chmod -R 755 target/$BALDIST/etc/profile.d

#cp linux/ballerina-home.sh target/$BALDIST/etc/profile.d/.
#sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/etc/profile.d/ballerina-home.sh

cp -R linux/DEBIAN target/$BALDIST/DEBIAN
sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/DEBIAN/postinst
sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/DEBIAN/postrm
sed -i -e 's/__BALLERINA_VERSION__/'$BALLERINA_VERSION'/g' target/$BALDIST/DEBIAN/control

dpkg-deb --build target/$BALDIST

echo $BALDIST "build completed at" $(date +"%Y-%m-%d %H:%M:%S")



