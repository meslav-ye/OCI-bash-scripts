#!/bin/bash

# Scaling and restarting nodes on Oracle Cloud Infrastrucure
# Prerequisite:
# 	Installed OCI Cli
#	Configured OCI Cli

#https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.6.0/oci_cli_docs/cmdref/ce.html
#######################################################################################################################

Help()
{
   # Display Help
   echo "Usage: k8automata.sh [OPTION...]"
   echo ""
   echo
   echo "   Command summary: k8automata.sh [-i|-r|-n|-h]"
   echo "   OPTIONS:"
   echo "       -i [text]       MUST Provide node pool id (OCID)."
   echo "       -r              Restart/reboot existing nodes in nodegroup."
   echo "       -n [text]       Scale nodes up or down. Provide number of nodes."
   echo "       -h              Print this help."
   
   echo
}

#######################################################################################################################
#--------------------------------------------------------------------------------------------------------

# oci ce node-pool update [options] 
# https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.6.0/oci_cli_docs/cmdref/ce/node-pool/update.html

UpdateNodePool(){
    echo "------------------------------"
    echo "## Scaling to $number nodes ##"
    echo "------------------------------"
    echo "DATA:"
    echo ""
    #--force to execute without prompting
    oci ce node-pool update --node-pool-id $id --size $number --force
}

Restart(){
    echo ""
    echo "## Reseting ##"
    num=$(oci ce node-pool get --node-pool-id $id | grep '"size":' | tr -d '"size": ')
    echo "Current number of nodes $num"
    i=$num
    while true
    do
        i=$((i-1))
        oci ce node-pool update --node-pool-id $id --size $i --force
        echo "Current number of nodes $i"
        sleep 2
        if [ $i == 0 ]
        then
            break
        fi
    done
    sleep 1
    while true
    do
        i=$((i+1))
        oci ce node-pool update --node-pool-id $id --size $i --force
        echo "Current number of nodes $i"
        sleep 2
        if [ $i == $num ]
        then
            break
        fi
    done
}

#--------------------------------------------------------------------------------------------------------

while getopts i:n:rh flag
do
    case "${flag}" in
        i) id=${OPTARG};;
        r) reset=1;;
        n) number=${OPTARG};;
        h) Help
            exit;;
    esac
done


if [ -z "$id" ]
then
      Help
else
    if ! [ -z "$reset" ]
    then
        Restart
        echo ""
        echo "Reseting: "
        echo "=== DONE ==="
        exit
    elif ! [ -z "$number" ]
    then
        UpdateNodePool
        echo ""
        echo "Updating node pool: "
        echo "=== DONE ==="
        exit
    else
        Help
    fi
fi

set -ex
