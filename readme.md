# Certificate Request Generator

This repository contains a single script which allows you to create a Certificate Request which can then be signed
by a CA produced by the project located here <TODO - ADD URL>:


This generator allows the creation of CN certificates as well as multi-domain certificates (SAN).

Wildcards are supported for both CN and SAN.

# Create a Certificate Request

1. Execute this command `./createRequest.sh <certName>` and answer the prompts.  Note that if you use SAN then the first SAN MUST be equal to the CN to be compatible with most SSL validators.
2. A tgz file is produced.  This file contains only the requests itself which is non-sensitive information (IE. Doesn't contain the private key).
3. The request can be signed by using the CA utilities located here : <TODO - ADD URL>.
4. Signing the request will produce the certificate and the chain.
5. Private key that goes with the certificate was produced in step 1 and is located in <certName/private/<certName>.key
