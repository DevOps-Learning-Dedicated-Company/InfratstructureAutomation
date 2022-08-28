#!/bin/bash
echo "processing parameters to assign nsg"
while [ "$1" != "" ]; do
    case $1 in
        -g | --resource-group ) shift
                                RGNAME=$1
                                ;;
        --resource-group-env )  shift
                                RGNAME=${!1}
                                ;;
        -nn | --nsg-name )      shift
                                NSGNAME=$1
                                ;;
        --nsg-name-env )        shift
                                NSGNAME=${!1}
                                ;;
        -vn | --vnet-name )     shift
                                VNETNAME=$1
                                ;;
        --vnet-name-env )       shift
                                VNETNAME=${!1}
                                ;;
        -s | --subnet-name )    shift
                                SUBNETNAME=$1
                                ;;
        --subnet-name-env )     shift
                                SUBNETNAME=${!1}
                                ;;
    esac
    shift
done

if [[ -z "${RGNAME}" ]]; then
    RGNAME=automated-bash-group
fi

if [[ -z "${NSGNAME}" ]]; then
    NSGNAME=automated-bash-nsg
fi

if [[ -z "${VNETNAME}" ]]; then
    VNETNAME=automated-bash-vnet
fi

if [[ -z "${SUBNETNAME}" ]]; then
    SUBNETNAME=subnet1
fi

echo "using nsg name: "$NSGNAME
echo "using vnet name: "$VNETNAME
echo "using subnet name: "$SUBNETNAME

az network vnet subnet update -g $RGNAME -n $SUBNETNAME --vnet-name $VNETNAME --network-security-group $NSGNAME
