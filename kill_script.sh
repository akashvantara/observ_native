#!/bin/sh

PS=$(ps -x)
EXIT_STATUS=""

if [ $( echo $PS | grep 'node_exporter' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'node_exporter' )
	echo "Killing node_exporter with PID: $PID"
	kill $PID
else
	echo "node_exporter is not running"
	EXIT_STATUS="1"
fi

if [ $( echo $PS | grep 'loki-linux-amd64' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'loki-linux-amd64' )
	echo "Killing Loki with PID: $PID"
	kill $PID
else
	echo "Loki is not running"
	EXIT_STATUS="1"
fi

if [ $( echo $PS | grep 'grafana' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'grafana' )
	echo "Killing Grafana with PID: $PID"
	kill $PID
else
	echo "Grafana is not running"
	EXIT_STATUS="1"
fi

if [ $( echo $PS | grep 'otelcol-contrib' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'otelcol-contrib' )
	echo "Killing Otel with PID: $PID"
	kill $PID
else
	echo "Otel is not running"
	EXIT_STATUS="1"
fi

if [ -z $EXIT_STATUS ]; then
	exit 0
else
	exit 1
fi
