#!/bin/bash
set -e
set -o pipefail


if [[ -z "${RELAY_ADDRESS}" ]]
then
    echo "RELAY_ADDRESS not defined"
    sleep 5
fi

torrc_file="/etc/tor/torrc.${RELAY_TYPE}"

sed -i 's/${RELAY_NICKNAME}/'"$RELAY_NICKNAME"'/g' "$torrc_file"
sed -i 's/${RELAY_ADDRESS}/'"$RELAY_ADDRESS"'/g' "$torrc_file"
sed -i 's/${CONTACT_GPG_FINGERPRINT}/'"$CONTACT_GPG_FINGERPRINT"'/g' "$torrc_file"
sed -i 's/${CONTACT_NAME}/'"$CONTACT_NAME"'/g' "$torrc_file"
sed -i 's/${CONTACT_EMAIL}/'"$CONTACT_EMAIL"'/g' "$torrc_file"
sed -i 's/${RELAY_BANDWIDTH_RATE}/'"$RELAY_BANDWIDTH_RATE"'/g' "$torrc_file"
sed -i 's/${RELAY_BANDWIDTH_BURST}/'"$RELAY_BANDWIDTH_BURST"'/g' "$torrc_file"
sed -i 's/${RELAY_PORT}/'"$RELAY_PORT"'/g' "$torrc_file"

echo "Dumping torrc..."
cat "$torrc_file"

exec tor -f "$torrc_file"
