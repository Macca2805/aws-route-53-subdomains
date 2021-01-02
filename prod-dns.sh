#!/usr/bin/env zsh
set -euo pipefail

HOSTED_ZONE=$(aws route53 list-hosted-zones-by-name --dns-name dev.macklin.xyz. --profile dev | jq -r '.HostedZones[0].Id')
NAME_SERVERS=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE --profile dev | jq -r '.ResourceRecordSets' | jq -r 'map(select(.Type == "NS"))' | jq -r '.[0].ResourceRecords' | jq -r 'map(.Value)')

aws cloudformation create-stack --template-body file://prod-dns.yml --stack-name dns --profile prod \
  --parameters \
    ParameterKey=DevNameServer1,ParameterValue=$(echo $NAME_SERVERS | jq '.[0]') \
    ParameterKey=DevNameServer2,ParameterValue=$(echo $NAME_SERVERS | jq '.[1]') \
    ParameterKey=DevNameServer3,ParameterValue=$(echo $NAME_SERVERS | jq '.[2]') \
    ParameterKey=DevNameServer4,ParameterValue=$(echo $NAME_SERVERS | jq '.[3]')
