#!/bin/bash
echo "processing parameters for backup creation"
while [ "$1" != "" ]; do
    case $1 in
        -g | --resource-group )  shift
                                 RGNAME=$1
                                 ;;
        --resource-group-env )   shift
                                 RGNAME=${!1}
                                 ;;
        -a | --app-name )        shift
                                 SERVICE=$1
                                 ;;
        --app-name-env )         shift
                                 SERVICE=${!1}
                                 ;;
        -na | --name )           shift
                                 STORAGE=$1
                                 ;;
        --name-env )             shift
                                 STORAGE=${!1}
                                 ;;
        -s | --schedule )        shift
                                 SCHEDULE=$1
                                 ;;
        --schedule-env )         shift
                                 SCHEDULE=${!1}
                                 ;;  
        -r | --retention-policy ) shift
                                  RETENTION=$1
                                  ;;
        --retention-policy-env ) shift
                                 RETENTION=${!1}
                                 ;;         
        -d | --databases )       shift
                                 DB=$1
                                 ;;
        --databases-env ) shift
                                 DB=${!1}
                                 ;;         
    esac
    shift
done

if [[ -z "${RGNAME}" ]]; then
    RGNAME=automated-bash-group
fi

if [[ -z "${SERVICE}" ]]; then
    SERVICE=LinuxContainerApp
fi

if [[ -z "${STORAGE}" ]]; then
    STORAGE=automatedbashstorage
fi

if [[ -z "${SCHEDULE}" ]]; then
    SCHEDULE=1d
fi

if [[ -z "${RETENTION}" ]]; then
    RETENTION=10
fi

BACKUPNAME=backupcontainer01
EXPIRY=$(date -I -d "$(date) + 7 days")

echo "resource group name: "$RGNAME
echo "app name: $SERVICE"
echo "storage account name: $STORAGE"
echo "schedule: $SCHEDULE"
echo "retention policy: $RETENTION"
echo "backup name: $BACKUPNAME"

echo "assigning key value"
KEY=$(az storage account keys list --account-name $STORAGE --resource-group $RGNAME -o json --query [0].value --verbose | tr -d '"')

echo "creating a storage container"
az storage container create\
    --name $BACKUPNAME\
    --account-key $KEY\
    --account-name $STORAGE\
    --verbose

echo "creating sas token"
SASTOKEN=$(az storage container generate-sas --account-name $STORAGE --name $BACKUPNAME --account-key $KEY --expiry $EXPIRY --permissions rwdl --output tsv --verbose)

echo "creating sasurl"
SASURL=https://$STORAGE.blob.core.windows.net/$BACKUPNAME?$SASTOKEN

if [[ -z "${DATABASES}" ]]; then
    echo "creating webapp config backup"
    az webapp config backup create\
        --backup-name $BACKUPNAME\
        --container-url $SASURL\
        --resource-group $RGNAME\
        --webapp-name $SERVICE\
        --verbose

    echo "updating webapp backup"
    az webapp config backup update\
        --resource-group $RGNAME\
        --backup-name $BACKUPNAME\
        --webapp-name $SERVICE\
        --frequency $SCHEDULE\
        --retention $RETENTION\
        --container-url $SASURL\
        --retain-one TRUE\
        --verbose
else
    echo "creating webapp config backup"
    az webapp config backup create\
        --backup-name $BACKUPNAME\
        --container-url $SASURL\
        --resource-group $RGNAME\
        --webapp-name $SERVICE\
        --db-name $DATABASES\
        --verbose

    echo "updating webapp backup"
    az webapp config backup update\
        --resource-group $RGNAME\
        --backup-name $BACKUPNAME\
        --webapp-name $SERVICE\
        --frequency $SCHEDULE\
        --retention $RETENTION\
        --container-url $SASURL\
        --retain-one TRUE\
        --db-name $DATABASES\
        --verbose
fi
