#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
    echo "ERROR: .env file not found"
    exit 1
fi

if [ ! -f secrets/gmail_app_password ]; then
    echo "ERROR: Gmail app password file not found"
    exit 1
fi

set -a
source .env
set +a

: "${GMAIL_ADDRESS:?GMAIL_ADDRESS is required}"

export GMAIL_ADDRESS

envsubst '${GMAIL_ADDRESS}' \
    < alertmanager/alertmanager.yml.template \
    > alertmanager/alertmanager.yml

chmod 644 alertmanager/alertmanager.yml
chmod 600 secrets/gmail_app_password
setfacl -m u:65534:r secrets/gmail_app_password

echo "Alertmanager configuration generated successfully."
