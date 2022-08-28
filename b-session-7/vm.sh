#!/bin/bash
echo "processing parameters for vm creation"
while [ "$1" != "" ]; do
    case $1 in
        -g | --resource-group ) shift
                                RGNAME=$1
                                ;;
        --resource-group-env )  shift
                                RGNAME=${!1}
                                ;;
        -vmn | --vm-name )      shift
                                VMNAME=$1
                                ;;
        --vm-name-env )         shift
                                VMNAME=${!1}
                                ;;
        -i | --image )          shift
                                IMAGE=$1
                                ;;
        --image-env )           shift
                                IMAGE=${!1}
                                ;;
        -si | --size )          shift
                                SIZE=$1
                                ;;
        --size-env )            shift
                                SIZE=${!1}
                                ;;
        -st | --storage-sku )   shift
                                SKU=$1
                                ;;
        --storage-sku-env )     shift
                                SKU=${!1}
                                ;;
        -v | --vnet-name )      shift
                                VNETNAME=$1
                                ;;
        --vnet-name-env )       shift
                                VNETNAME=${!1}
                                ;;
        -su | --subnet-name )   shift
                                SUBNETNAME=$1
                                ;;
        --subnet-name-env )     shift
                                SUBNETNAME=${!1}
                                ;;
        -d | --dns-name )       shift
                                DNSNAME=$1
                                ;;
        --dns-name-env )        shift
                                DNSNAME=${!1}
                                ;;
        -r | --reserved-ip )    shift
                                IP=$1
                                ;;
        --reserved-ip-env )     shift
                                IP=${!1}
                                ;;               
    esac
    shift
done

LOCATION=ukwest
NSGRULE=NONE

if [[ -z "${RGNAME}" ]]; then
    RGNAME=automated-bash-group
fi

if [[ -z "${VMNAME}" ]]; then
    VMNAME=auto-vm-01
fi

if [[ -z "${IMAGE}" ]]; then
    IMAGE=Canonical:UbuntuServer:18.04-LTS:latest
fi

if [[ -z "${SIZE}" ]]; then
    SIZE=Standard_DS1_v2
fi

if [[ -z "${SKU}" ]]; then
    SKU=Standard_LRS
fi

if [[ -z "${VNETNAME}" ]]; then
    VNETNAME=automated-bash-vnet
fi

if [[ -z "${SUBNETNAME}" ]]; then
    SUBNETNAME=subnet1
fi

if [[ "${IMAGE}" == "Canonical:WindowsServer:2019:latest" ]]; then
    NSGRULE=RDP
fi

echo "using resource group name: "$RGNAME
echo "using vm name: "$VMNAME
echo "using image: "$IMAGE
echo "using size: "$SIZE
echo "using disk pricing tier: "$SKU
echo "using vnet name: "$VNETNAME
echo "using subnet name: "$SUBNETNAME
echo "using location: "$LOCATION
echo "using dns name: "$DNSNAME
echo "using reserved ip address: "$IP

if [[ "$DNSNAME" == "" && "$IP" == "" ]]; then
    az vm create\
        --name $VMNAME\
        --resource-group $RGNAME\
        --image $IMAGE\
        --vnet-name $VNETNAME\
        --subnet $SUBNETNAME\
        --size $SIZE\
        --os-disk-delete-option Delete\
        --location $LOCATION\
        --nic-delete-option Delete\
        --storage-sku $SKU\
        --public-ip-address ""\
        --generate-ssh-keys\
        --nsg-rule $NSGRULE

elif [[ "$DNSNAME" != "" && "$IP" == "" ]]; then
    az vm create\
        --name $VMNAME\
        --resource-group $RGNAME\
        --image $IMAGE\
        --vnet-name $VNETNAME\
        --subnet $SUBNETNAME\
        --generate-ssh-keys\
        --public-ip-address ""\
        --public-ip-address-dns-name $DNSNAME\
        --size $SIZE\
        --os-disk-delete-option Delete\
        --location $LOCATION\
        --nic-delete-option Delete\
        --storage-sku $SKU\
        --generate-ssh-keys\
        --nsg-rule $NSGRULE

elif [[ "$DNSNAME" == "" && "$IP" != "" ]]; then
    az vm create\
        --name $VMNAME\
        --resource-group $RGNAME\
        --image $IMAGE\
        --vnet-name $VNETNAME\
        --subnet $SUBNETNAME\
        --public-ip-address $IP\
        --public-ip-address-allocation static\
        --size $SIZE\
        --os-disk-delete-option Delete\
        --location $LOCATION\
        --nic-delete-option Delete\
        --storage-sku $SKU\
        --generate-ssh-keys\
        --nsg-rule $NSGRULE
else
    az vm create\
        --name $VMNAME\
        --resource-group $RGNAME\
        --image $IMAGE\
        --vnet-name $VNETNAME\
        --subnet $SUBNETNAME\
        --public-ip-address $IP\
        --public-ip-address-dns-name $DNSNAME\
        --public-ip-address-allocation static\
        --size $SIZE\
        --os-disk-delete-option Delete\
        --location $LOCATION\
        --nic-delete-option Delete\
        --storage-sku $SKU\
        --generate-ssh-keys\
        --nsg-rule $NSGRULE
fi