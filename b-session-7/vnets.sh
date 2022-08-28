#!/bin/bash
echo "processing parameters for vnet creation"
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
        -n | --vnet-name )       shift
                                 VNETNAME=$1
                                 ;;
        --vnet-name-env )        shift
                                 VNETNAME=${!1}
                                 ;;
        -a | --vnet-address )    shift
                                 VNETADD=$1
                                 ;;
        --vnet-address-env )     shift
                                 VNETADD=${!1}
                                 ;;
        -s | --subnets-addresses ) shift
                                   SUBNETS=( $@ )
                                   ;;
        --subnets-addresses-env )  shift
                                   SUBNETS=${!@}
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

if [[ -z "${VNETNAME}" ]]; then
    VNETNAME=automated-bash-vnet
fi

if [[ -z "${VNETADD}" ]]; then
    VNETADD=10.0.0.0/16
fi

if [[ -z "${SUBNETS}" ]]; then
    SUBNETS=(subnet1 10.0.0.0/24 subnet2 10.0.1.0/24)
fi

length=${#SUBNETS[@]}

echo "using resource group name: "$RGNAME
echo "using location: "$LOCATION
echo "using vnet name: "$VNETNAME
echo "using vnet address: "$VNETADD
echo "using subnets: "${SUBNETS[@]}

az group create --name $RGNAME --location $LOCATION

az network vnet create --resource-group $RGNAME --location $LOCATION --name $VNETNAME --address-prefix $VNETADD

for ((i = 0; i < $length; i+=2)); do
    az network vnet subnet create --resource-group $RGNAME --vnet-name $VNETNAME --name ${SUBNETS[$i]} --address-prefixes ${SUBNETS[$((i + 1))]}
done

echo "==================================================================="
echo "Done"