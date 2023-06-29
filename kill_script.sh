#!/bin/sh

PS=$(ps -x)

if [ $( echo $PS | grep 'loki-linux-amd64' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'loki-linux-amd64' )
	echo "Killing Loki with PID: $PID"
	kill $PID
else
	echo "Loki is not running"
fi

if [ $( echo $PS | grep 'grafana' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'grafana' )
	echo "Killing Grafana with PID: $PID"
	kill $PID
else
	echo "Grafana is not running"
fi

if [ $( echo $PS | grep 'otelcol-contrib' | wc -c ) -gt 0 ]; then
	PID=$( pidof 'otelcol-contrib' )
	echo "Killing Otel with PID: $PID"
	kill $PID
else
	echo "Otel is not running"
fi

exit 0
