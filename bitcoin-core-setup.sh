#!/bin/sh

VERSION=22.0
BITCOINFOLDER=bitcoin-$VERSION
BITCOINFILE=$BITCOINFOLDER-x86_64-linux-gnu.tar.gz

useradd bitcoin
mkdir -p /home/bitcoin
chown -R bitcoin /home/bitcoin
getent group bitcoin &> /dev/null || groupadd bitcoin

if [ ! -f "$BITCOINFILE" ]; then
    wget https://bitcoin.org/bin/bitcoin-core-$VERSION/$BITCOINFILE
fi

rm -rf $BITCOINFOLDER
tar -xvf $BITCOINFILE

cd $BITCOINFOLDER
cp -R * /usr/local/

curl https://raw.githubusercontent.com/bitcoin/bitcoin/master/contrib/init/bitcoind.service | sed 's/\/usr\//\/usr\/local\//' > /etc/systemd/system/bitcoind.service

curl https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/examples/bitcoin.conf > /etc/bitcoin/bitcoin.conf

systemctl daemon-reload

systemctl enable bitcoind

systemctl stop bitcoind

systemctl start bitcoind

systemctl status bitcoind.service
