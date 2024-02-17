#/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: ./createRequest.sh <certName>"
  exit 1
fi

mkdir $1
cd $1
mkdir cert
mkdir private
mkdir csr
chmod 700 private

cat <<HEREDOC > openssl.cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
HEREDOC

read -p "Country [CA]>" COUNTRY
export COUNTRY=${COUNTRY:-"CA"}
read -p "State [Quebec]>" STATE
export STATE=${STATE:-"Quebec"}
read -p "City [Gatineau]>" CITY
export CITY=${CITY:-"Gatineau"}
read -p "Org [ACME, INC]>" ORG
export ORG=${ORG:-"ACME, INC"}
read -p "Division>" DIVISION
read -p "CN>" CN

cat <<HEREDOC >> openssl.cnf
C = $COUNTRY
ST = $STATE
L = $CITY
O = $ORG
OU = $DIVISION
CN = $CN
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
HEREDOC

read -p "Do you want SANs [Y/N]>" SAN
if [[ $SAN =~ ^[Yy]$ ]]; then
  echo "subjectAltName = @alt_names" >> openssl.cnf
  echo "[alt_names]" >> openssl.cnf

  index=1
  while true; do
    read -p "DNS.$index>" SAN
    if [ -z "$SAN" ]; then
       cat csr/$1.san >> openssl.cnf
       break;
    fi
    echo "DNS.$index = $SAN" >> csr/$1.san
    index=$((index+1))
  done
fi

echo "Here's the settings:"
cat openssl.cnf
read -p "Is this OK [y/n]?" OK

if [[ $OK =~ ^[Yy]$ ]]; then
  openssl genrsa -out private/$1.key 2048
  chmod 400 private/$1.key
  openssl req -config openssl.cnf -key private/$1.key -new -sha256 -out csr/$1.csr

  tar czf ../$1.tgz csr/$1.csr csr/$1.san
  echo "Certificate request is stored into $1.tgz"
else
  echo "Aborting"
fi
