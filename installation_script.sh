#!/bin/sh

# Address of the packages
OTEL_PACKAGE_URL='https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.80.0/otelcol-contrib_0.80.0_linux_amd64.tar.gz'
GRAFANA_PACKAGE_URL='https://dl.grafana.com/oss/release/grafana-10.0.1.linux-amd64.tar.gz'
LOKI_PACKAGE_URL='https://github.com/grafana/loki/releases/download/v2.8.2/loki-linux-amd64.zip'

OTEL_PACKAGE_NAME=$(echo $OTEL_PACKAGE_URL | rev | cut -d '/' -f 1 | rev)
GRAFANA_PACKAGE_NAME=$(echo $GRAFANA_PACKAGE_URL | rev | cut -d '/' -f 1 | rev)
LOKI_PACKAGE_NAME=$(echo $LOKI_PACKAGE_URL | rev | cut -d '/' -f 1 | rev)

EXIT_REASON=''

abort_script()	{
	echo "Script failed to complete. Reason: " $EXIT_REASON
	exit 1
}

# Check required packages
echo "Checking all the required packages..."

IS_PRESENT=$(which curl)
if [ $? -eq 0 ]; then
	echo '`curl` is present!';
else
	EXIT_REASON='`curl` not present\n'
	abort_script
fi

IS_PRESENT=$(which tar)
if [ $? -eq 0 ]; then
	echo '`tar` is present!';
else
	EXIT_REASON='`tar` not present\n'
	abort_script
fi

IS_PRESENT=$(which unzip)
if [ $? -eq 0 ]; then
	echo '`unzip` is present!';
else
	EXIT_REASON='`unzip` not present\n'
	abort_script
fi

IS_PRESENT=$(which make)
if [ $? -eq 0 ]; then
	echo '`make` is present!';
else
	echo 'make is not present in the system you can manually run the run_script and cleanup_script'
fi


# Downloading the required things
echo "Downloading all the required package..."

PACKAGE_OTEL='otelcol-contrib'
if [ -f $OTEL_PACKAGE_NAME ]; then
	echo "'$PACKAGE_OTEL' already present!"
else
	IS_SUCCESS=$(curl -fLO $OTEL_PACKAGE_URL)
	if [ $? -eq 0 ]; then
		echo "'$PACKAGE_OTEL' downloaded!";
	else
		EXIT_REASON="Cannot download '$PACKAGE_OTEL' for some reason"
		abort_script
	fi
fi

PACKAGE_GRAFANA='grafana'
if [ -f $GRAFANA_PACKAGE_NAME ]; then
	echo "'$PACKAGE_GRAFANA' already present!"
else
	IS_SUCCESS=$(curl -fLO $GRAFANA_PACKAGE_URL)
	if [ $? -eq 0 ]; then
		echo "'$PACKAGE_GRAFANA' downloaded!";
	else
		EXIT_REASON="Cannot download '$PACKAGE_GRAFANA' for some reason"
		abort_script
	fi
fi

PACKAGE_LOKI='loki'
if [ -f $LOKI_PACKAGE_NAME ]; then
	echo "'$PACKAGE_LOKI' already present!"
else
	IS_SUCCESS=$(curl -fLO $LOKI_PACKAGE_URL)
	if [ $? -eq 0 ]; then
		echo "'$PACKAGE_LOKI' downloaded!";
	else
		EXIT_REASON="Cannot download '$PACKAGE_LOKI' for some reason"
		abort_script
	fi
fi

# Unpacking the packages
IS_SUCCESS=$(tar -xvf $OTEL_PACKAGE_NAME)
if [ $? -eq 0 ]; then
	echo "$OTEL_PACKAGE_NAME unpacked!"
	rm LICENSE README.md
else
	EXIT_REASON="Could not unpack '$OTEL_PACKAGE_NAME'"
	abort_script
fi

if ! mkdir -p $PACKAGE_GRAFANA; then
	echo "Directory $PACKAGE_GRAFANA already seem to exist"
fi

IS_SUCCESS=$(tar -xvf $GRAFANA_PACKAGE_NAME -C $PACKAGE_GRAFANA --strip-components 1)
if [ $? -eq 0 ]; then
	echo "$GRAFANA_PACKAGE_NAME unpacked!"
else
	EXIT_REASON="Could not unpack '$GRAFANA_PACKAGE_NAME'"
	abort_script
fi

IS_SUCCESS=$(unzip $LOKI_PACKAGE_NAME)
if [ $? -eq 0 ]; then
	echo "$LOKI_PACKAGE_NAME unpacked!"
else
	EXIT_REASON="Could not unpack '$LOKI_PACKAGE_NAME'"
	abort_script
fi

# Change all the director name and do all the house keeping
echo "Creating directory 'otel' in $(pwd) for $PACKAGE_OTEL to use for file storage"
mkdir -p otel

echo "Creating directory 'loki' in $(pwd) for $PACKAGE_LOKI to use for configurations and storage"
mkdir -p loki

echo "Creating log directory for keeping logs of all observable services"
mkdir -p logs

echo "Installation done!, please proceed with run_script.sh if you want to run all the application at once"
