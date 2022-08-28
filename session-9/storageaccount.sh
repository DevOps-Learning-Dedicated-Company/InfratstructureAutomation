#!/bin/bash
echo "processing parameters for storage account creation"
while [ "$1" != "" ]; do
    case $1 in
        -g | --resource-group )  shift
                                 RGNAME=$1
                                 ;;
        --resource-group-env )   shift
                                 RGNAME=${!1}
                                 ;;
        -l | --location )        shift
                                 LOCATION=$1
                                 ;;
        --location-env )         shift
                                 LOCATION=${!1}
                                 ;;
        -na | --name )           shift
                                 STORAGE=$1
                                 ;;
        --name-env )             shift
                                 STORAGE=${!1}
                                 ;;
        -p | --pricing-tier )    shift
                                 PRICING=$1
                                 ;;
        --pricing-tier-env )     shift
                                 PRICING=${!1}
                                 ;;                 
    esac
    shift
done

if [[ -z "${RGNAME}" ]]; then
    RGNAME=automated-bash-group
fi

if [[ -z "${LOCATION}" ]]; then
    LOCATION=ukwest
fi

if [[ -z "${STORAGE}" ]]; then
    STORAGE=automatedbashstorage
fi

if [[ -z "${PRICING}" ]]; then
    PRICING=Standard_LRS
fi

echo "resource group name: "$RGNAME
echo "location: "$LOCATION
echo "app service name: "$STORAGE
echo "pricing tier: "$PRICING

#az group create --name $RGNAME --location $LOCATION

az storage account create\
    --resource-group $RGNAME\
    --name $STORAGE\
    --location $LOCATION\
    --sku $PRICING