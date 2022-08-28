#!/bin/bash
echo "processing parameters for app service creation"
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
                                 PLANNAME=$1
                                 ;;
        --name-env )             shift
                                 PLANNAME=${!1}
                                 ;;
        -n | --now )             shift
                                 NOW=$1
                                 ;;
        --now-env )              shift
                                 NOW=${!1}
                                 ;;
        -p | --pricing-tier )    shift
                                 PRICING=$1
                                 ;;
        --pricing-tier-env )     shift
                                 PRICING=${!1}
                                 ;;
        -i | --image-docker )    shift
                                 IMAGE=$1
                                 ;;
        --image-docker-env )     shift
                                 IMAGE=${!1}
                                 ;;  
        -a | --app-name )        shift
                                 APPNAME=$1
                                 ;;
        --app-name-env )         shift
                                 APPNAME=${!1}
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

if [[ -z "${PLANNAME}" ]]; then
    PLANNAME=automated-app-service-plan
fi

if [[ -z "${NOW}" ]]; then
    NOW=1
fi

if [[ -z "${PRICING}" ]]; then
    PRICING=S1
fi

if [[ -z "${IMAGE}" ]]; then
    IMAGE=mcr.microsoft.com/dotnet/samples:aspnetapp
fi

if [[ -z "${APPNAME}" ]]; then
    APPNAME=LinuxContainerApp
fi

echo "resource group name: "$RGNAME
echo "location: "$LOCATION
echo "app service name: "$PLANNAME
echo "number of workers: "$NOW
echo "pricing tier: "$PRICING
echo "docker hub image: "$IMAGE
echo "app name: "$APPNAME

az group create --name $RGNAME --location $LOCATION

az appservice plan create\
    -g $RGNAME\
    -n $PLANNAME\
    --location $LOCATION\
    --is-linux\
    --number-of-workers $NOW\
    --sku $PRICING

az webapp create\
    --resource-group $RGNAME\
    --plan $PLANNAME\
    --name $APPNAME\
    --deployment-container-image-name $IMAGE

echo "========================================================="
echo "done"