#!/bin/sh
        
cd ${CERTS_DIR}
if [ -z "$( ls -A . )" ]; then
	cd /usr/share/elasticsearch
	./bin/elasticsearch-certutil ca --silent --pem --out ${CERTS_DIR}/elastic-stack-ca.zip
	unzip -q ${CERTS_DIR}/elastic-stack-ca.zip -d ${CERTS_DIR}
	rm ${CERTS_DIR}/elastic-stack-ca.zip
	./bin/elasticsearch-certutil cert --silent --pem --in /tmp/instances.yml --ca-cert ${CERTS_DIR}/ca/ca.crt --ca-key ${CERTS_DIR}/ca/ca.key --out ${CERTS_DIR}/bundle.zip
	unzip -q ${CERTS_DIR}/bundle.zip -d ${CERTS_DIR}
	rm ${CERTS_DIR}/bundle.zip
	#ls -l {CERTS_DIR}
fi