#!/bin/bash
echo "processing parameters for resources deletion"
while [ "$1" != "" ]; do
    case $1 in
        -g | --resource-group )  shift
                                 RGNAME=$1
                                 ;;
        --resource-group-env )   shift
                                 RGNAME=${!1}
                                 ;;               
    esac
    shift
done

if [[ -z "${RGNAME}" ]]; then
    RGNAME=automated-bash-group
fi

echo "resource group name: "$RGNAME

RESOURCES="$(az resource list --resource-group $RGNAME | grep subscriptions | awk -F \" '{print $4}')"

for ID in $RESOURCES; do
    echo $ID
    az resource delete --resource-group $RGNAME --ids "$ID" --verbose 
done

ROUND2="$(az resource list --resource-group $RGNAME | grep subscriptions | awk -F \" '{print $4}')"

for ID in $ROUND2; do
    echo $ID
    az resource delete --resource-group $RGNAME --ids "$ID" --verbose 
done