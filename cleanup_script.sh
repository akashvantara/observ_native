#!/bin/sh

echo "Removing all the archives"
rm *.gz
rm *.zip

echo "Removing all the unnecessary folders with their data"
rm -r otel loki grafana logs

echo "Removing all the binaries"
rm loki-linux-amd64 otelcol-contrib

exit 0
