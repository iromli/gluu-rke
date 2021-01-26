#!/bin/sh

# if [ ! -f dhparam.pem ]; then
#     openssl dhparam -out dhparam.pem 2048
# fi

# kubectl -n gluu create secret generic tls-dhparam --from-file=dhparam.pem

kubectl -n gluu get secret gluu -o json \
    | grep '"ssl_cert":' \
    | awk -F '"' '{print $4}' \
    | base64 --decode > ingress.crt

kubectl -n gluu get secret gluu -o json \
    | grep '"ssl_key":' \
    | awk -F '"' '{print $4}' \
    | base64 --decode > ingress.key

kubectl -n gluu create secret tls tls-certificate --key ingress.key --cert ingress.crt
