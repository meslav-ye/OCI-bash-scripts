#!/bin/bash

# Power on/off Instance on Oracle Cloud Infrastrucure
# Prerequisite:
# 	Installed OCI Cli
#	Configured OCI Cli

#######################################################################################################################

Help()
{
   # Display Help
   echo "Usage: automata.sh [OPTION...]"
   echo ""
   echo
   echo "   Command summary: automata.sh [-i|-p|-s|-h]"
   echo "   OPTIONS:"
   echo "       -i [text]       MUST Provide instance id (OCID)."
   echo "       -p [text]       Power on||off. Provide on or off."
   echo "       -s [text]       Change compute shape. Provide shape. "  
   echo "       -h              Print this help."
   
   echo
}

#######################################################################################################################
#--------------------------------------------------------------------------------------------------------

#https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.6.0/oci_cli_docs/cmdref/compute/instance/action.html
PowerSwitch(){
    echo "## Running ##"
    echo "=== Power $power ==="
    echo ""
    echo "DATA:"
    echo ""
    echo $id
    if [ $power == "on" ]; then
        #oci compute instance action START
        oci compute instance action --action START --instance-id $id
    elif [ $power == "off" ]; then
        #oci compute instance action STOP
        oci compute instance action --action STOP --instance-id $id
    else
        Help
        exit
    fi
}

#https://docs.oracle.com/en-us/iaas/tools/oci-cli/2.9.9/oci_cli_docs/cmdref/compute/instance/update.html
ScaleCompute(){
    echo "### Scaling Compute Instance ###"
    echo ""
    echo "DATA:"
    echo ""
    oci compute instance update --instance-id $id --shape $compute
}
#--------------------------------------------------------------------------------------------------------

while getopts i:p:s:h flag
do
    case "${flag}" in
        i) id=${OPTARG};;
        p) power=${OPTARG};;
        s) compute=${OPTARG};;
        h) Help
            exit;;
    esac
done

if [ -z "$id" ]
then
      Help
else
    if ! [ -z "$power" ]
    then
        PowerSwitch
        echo ""
        echo "Power switch "
        echo "=== DONE ==="
        exit
    elif ! [ -z "$compute" ]
    then
        ScaleCompute
        echo ""
        echo "Scaling "
        echo "=== DONE ==="
        exit
    else
        Help
    fi
fi

set -ex
