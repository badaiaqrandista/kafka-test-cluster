#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

rm -f *.pem *.crt *.csr *.key *.jks index.txt* serial.txt*

VALIDITY=365

# Generate CA key
openssl req -new -x509 -keyout cacert.key -out cacert.crt -days $VALIDITY -subj '/CN=ca1.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US' -passin pass:confluent

for i in broker1 broker2 broker3 producer consumer
do
	echo $i

  # Import the CA cert
  keytool -keystore kafka.$i.truststore.jks -alias CARoot -import -file cacert.crt -storepass confluent -keypass confluent
  keytool -keystore kafka.$i.keystore.jks -alias CARoot -import -file cacert.crt -storepass confluent -keypass confluent

  # Create cert
  keytool -keystore kafka.$i.keystore.jks -alias $i -validity $VALIDITY -genkey -noprompt -dname "CN=quickstart.confluent.io, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" -storepass confluent -keypass confluent

  # Create cert request and sign it
  keytool -keystore kafka.$i.keystore.jks -alias $i -certreq -file kafka.$i.csr -storepass confluent -keypass confluent
  openssl x509 -req -CA cacert.crt -CAkey cacert.key -in kafka.$i.csr -out kafka.$i.crt -days $VALIDITY -CAcreateserial -passin pass:confluent -extfile ssl_extension

  # Import signed cert
  keytool -keystore kafka.$i.keystore.jks -alias $i -import -file kafka.$i.crt -storepass confluent -keypass confluent

  echo "confluent" > ${i}_sslkey_creds
  echo "confluent" > ${i}_keystore_creds
  echo "confluent" > ${i}_truststore_creds
done
