#!/bin/sh

echo "Staring loki in background..."
./loki-linux-amd64 -config.file loki-local-config.yaml > logs/loki.log 2> logs/loki_err.log &

echo "Starting grafana in background..."
cd grafana/bin
./grafana server > ../../logs/grafana.log 2> ../../logs/grafana_err.log &
cd ../..

echo "Starting otel collector in background..."
./otelcol-contrib --config config.yaml > logs/otel.log 2> logs/otel_err.log &
