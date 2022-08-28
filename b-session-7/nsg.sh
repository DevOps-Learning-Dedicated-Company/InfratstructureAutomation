#!/bin/bash
echo "processing parameters for nsg creation"
while [ "$1" != "" ]; do
    case $1 in
        -l | --location )       shift
                                LOCATION=$1
                                ;;
        --location-env )        shift
                                LOCATION=${!1}
                                ;;
        -n | --nsg-name )       shift
                                NSGNAME=$1
                                ;;
        --nsg-name-env )        shift
                                NSGNAME=${!1}
                                ;;
        -rn | --rule-name )     shift
                                RULENAME=$1
                                ;;
        --rule-name-env )       shift
                                RULENAME=${!1}
                                ;;      
        -r | --rules )          shift
                                RULES=( $@ )
                                ;;
        --rules-env )           shift
                                RULES=${!#}
                                ;;
    esac
    shift
done

if [[ -z "${LOCATION}" ]]; then
    LOCATION=ukwest
fi

if [[ -z "${NSGNAME}" ]]; then
    NSGNAME=automated-bash-nsg
fi

if [[ -z "${RULENAME}" ]]; then
    RULENAME=AllowAll
fi

if [[ -z "${RULES}" ]]; then
    RULES=(Allow Outbound Tcp)
fi

RGNAME=automated-bash-group
PRIORITY=100

echo "using resource group name: "$RGNAME
echo "using location: "$LOCATION
echo "using nsg name: "$NSGNAME
echo "using rule name: "$RULENAME
echo "using rules: "${RULES[@]}

az network nsg create -g $RGNAME -n $NSGNAME -l $LOCATION

az network nsg rule create\
    --resource-group $RGNAME\
    --nsg-name $NSGNAME\
    --name $RULENAME\
    --priority $PRIORITY\
    --access ${RULES[0]}\
    --direction ${RULES[1]}\
    --protocol ${RULES[2]}\
