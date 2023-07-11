#!/bin/sh

PS=$(ps -x)
IS_NODE_EXPORTER_RUNNING=""
if [ $( echo $PS | grep 'node_exporter' | wc -c ) -gt 0 ]; then
	IS_NODE_EXPORTER_RUNNING="y"
fi

IS_LOKI_RUNNING=""
if [ $( echo $PS | grep 'loki-linux-amd64' | wc -c ) -gt 0 ]; then
	IS_LOKI_RUNNING="y"
fi

IS_GRAFANA_RUNNING=""
if [ $( echo $PS | grep 'grafana' | wc -c ) -gt 0 ]; then
	IS_GRAFANA_RUNNING="y"
fi

IS_OTEL_RUNNING=""
if [ $( echo $PS | grep 'otelcol-contrib' | wc -c ) -gt 0 ]; then
	IS_OTEL_RUNNING="y"
fi

LS=$(ls)
IS_LOKI_AVAILABLE=""
if ([ $(echo $LS | grep 'loki-linux-amd64' | wc -c) -gt 0 ] && [ $(echo $LS | grep 'loki-local-config.yaml' | wc -c) -gt 0 ]); then
	IS_LOKI_AVAILABLE="y"
fi

IS_GRAFANA_AVAILABLE=""
if [ $(echo $LS | grep 'grafana' | wc -c) -gt 0 ]; then
	IS_GRAFANA_AVAILABLE="y"
fi
IS_OTEL_AVAILABLE=""
if ([ $(echo $LS | grep 'otelcol-contrib' | wc -c) -gt 0 ] && [ $(echo $LS | grep 'config.yaml' | wc -c) -gt 0 ]); then
	IS_OTEL_AVAILABLE="y"
fi

if ( [ -z "$IS_LOKI_AVAILABLE" ] || [ -z "$IS_GRAFANA_AVAILABLE" ] || [ -z "$IS_OTEL_AVAILABLE" ]); then
	if [ -z "$IS_LOKI_AVAILABLE" ]; then
		echo "Loki set-up not present"
	fi
	if [ -z "$IS_GRAFANA_AVAILABLE" ]; then
		echo "Grafana set-up not present"
	fi
	if [ -z "$IS_OTEL_AVAILABLE" ]; then
		echo "Otel set-up not present"
	fi

	echo "Please re-run installation script!"
	exit 1
fi

if [ -z "$IS_NODE_EXPORTER_RUNNING" ]; then
	echo "Staring loki in background..."
	./node_exporter-1.0.1.linux-amd64/node_exporter  > logs/node_exporter.log 2> logs/node_exporter_err.log &
else
	echo "node_exporter is already running..."
fi

if [ -z "$IS_LOKI_RUNNING" ]; then
	echo "Staring loki in background..."
	./loki-linux-amd64 -config.file loki-local-config.yaml > logs/loki.log 2> logs/loki_err.log &
else
	echo "Loki is already running..."
fi

if [ -z "$IS_GRAFANA_RUNNING" ]; then
	echo "Starting grafana in background..."
	cd grafana/bin
	./grafana server > ../../logs/grafana.log 2> ../../logs/grafana_err.log &
	cd ../..
else
	echo "Grafana is already running..."
fi

if [ -z "$IS_OTEL_RUNNING" ]; then
	echo "Starting otel collector in background..."
	./otelcol-contrib --config config.yaml > logs/otel.log 2> logs/otel_err.log &
else
	echo "Otel is already running..."
fi

exit 0
