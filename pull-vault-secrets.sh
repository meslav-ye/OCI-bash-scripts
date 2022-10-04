#!/bin/bash

# Pulling secret from Oracle Cloud Infrastrucure Vault
# Prerequisite:
# 	Installed OCI Cli
#	Configured OCI Cli

#######################################################################################################################

Help()
{
   # Display Help
   echo "Usage: pull-secrets.sh [OPTION...]"
   echo ""
   echo
   echo "   Command summary: pull-secrets.sh [-i|-h]"
   echo "   OPTIONS:"
   echo "       -i [text]       MUST Provide secret id (OCID)."
   echo "       -h              Print this help."
   
   echo
}

#######################################################################################################################
#--------------------------------------------------------------------------------------------------------

#https://docs.oracle.com/en-us/iaas/tools/oci-cli/2.9.10/oci_cli_docs/cmdref/secrets/secret-bundle/get.html
getSecretValue(){
    echo "## Pulling ##"
    echo ""
    echo "Secret:"
    secret=$(oci secrets secret-bundle get --secret-id $id | grep '"content":' | tr -d '"content": ,') 
    echo $secret
}

placeInHelm(){
    echo "## Replacing secret in Helm chart ##"
}

#--------------------------------------------------------------------------------------------------------

while getopts i:h flag
do
    case "${flag}" in
        i) id=${OPTARG};;
        h) Help
            exit;;
    esac
done

if [ -z "$id" ]
then
    Help
else
    getSecretValue
fi

placeInHelm
