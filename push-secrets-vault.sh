#!/bin/bash

# Pushing secret (files ending with -secret.yaml) to Oracle Cloud Infrastrucure Vault
# Prerequisite:
# 	Installed OCI Cli
#	Configured OCI Cli

#######################################################################################################################

Help()
{
   # Display Help
   echo "Usage: push-secrets.sh [OPTION...]"
   echo ""
   echo
   echo "   Command summary: push-secrets.sh [-c|-v|-k|-h]"
   echo "   OPTIONS:"
   echo "       -c [text]       MUST Provide compartment id (OCID)."
   echo "       -v [text]       MUST Provide vault id (OCID)."
   echo "       -k [text]       MUST Provide key id (OCID)."
   echo "       -h              Print this help."
   
   echo
}

#######################################################################################################################
#--------------------------------------------------------------------------------------------------------

#https://docs.oracle.com/en-us/iaas/tools/oci-cli/2.9.9/oci_cli_docs/cmdref/vault/secret/create-base64.html
pushToVault(){
    echo ""
    echo "## Pushing $secret_name ##"
    echo ""
    echo "Secret:"
    secret_content_b64=$(echo -n "$secret_content" | base64 -w 0)
    oci vault secret create-base64 -c $comp_id --secret-name $secret_name --vault-id $vault_id --secret-content-content "$secret_content_b64" --key-id $key_id
}

getSecretValue(){
    # CHANGE if needed
  FILES=$(find . -name "*-secret.yaml")
  i=0
  for f in $FILES
  do
    i=$((++i))
    echo ""
    echo "                              Secret number $i"
    echo "======================================================================================"
    echo "Processing $f" 
    secret_content=$(<$f)
    secret_name=$(echo ${f:2:(-5)})
    pushToVault
    echo "======================================================================================"
  done
}

#--------------------------------------------------------------------------------------------------------

while getopts c:v:k:h flag
do
    case "${flag}" in
        c) comp_id=${OPTARG};;
        v) vault_id=${OPTARG};;
        k) key_id=${OPTARG};;
        h) Help
            exit;;
    esac
done

if [ -z "$comp_id" ] && [ -z "$vault_id" ] && [ -z "$key_id" ]
then
    Help
else
    getSecretValue
fi

