#!/usr/bin/env zsh
set -euo pipefail

aws cloudformation create-stack --template-body file://dev-dns.yml --stack-name dns --profile dev