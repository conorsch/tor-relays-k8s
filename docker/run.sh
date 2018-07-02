#!/bin/bash
set -e
set -o pipefail


if [[ -z "${RELAY_ADDRESS}" ]]
then
    echo "RELAY_ADDRESS not defined"
    exit 1
fi

for relaytype in bridge middle exit; do
	sed -i 's/${RELAY_NICKNAME}/'"$RELAY_NICKNAME"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${RELAY_ADDRESS}/'"$RELAY_ADDRESS"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${CONTACT_GPG_FINGERPRINT}/'"$CONTACT_GPG_FINGERPRINT"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${CONTACT_NAME}/'"$CONTACT_NAME"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${CONTACT_EMAIL}/'"$CONTACT_EMAIL"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${RELAY_BANDWIDTH_RATE}/'"$RELAY_BANDWIDTH_RATE"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${RELAY_BANDWIDTH_BURST}/'"$RELAY_BANDWIDTH_BURST"'/g' "/etc/tor/torrc.$relaytype"
	sed -i 's/${RELAY_PORT}/'"$RELAY_PORT"'/g' "/etc/tor/torrc.$relaytype"
done

echo "Dumping torrc..."
cat /etc/tor/torrc.${RELAY_TYPE}

exec tor -f /etc/tor/torrc.${RELAY_TYPE}
