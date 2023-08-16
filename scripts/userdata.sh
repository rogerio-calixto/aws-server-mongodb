#!/bin/bash
apt-get update
apt-get -y upgrade
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sleep 10
sudo unzip -u awscliv2.zip
sleep 20
./aws/install
sleep 20
rm -f awscliv2.zip

sleep 10

# generate control file and copy to s3

METADATA="ubuntu@ip-$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" \
&& USR=$(echo $METADATA | sed s/[.]/-/g) \
&& echo "User: $USR"  >> server.txt
&& aws s3 cp server.txt ${s3-bucket}