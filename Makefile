install: installation_script.sh
	./installation_script.sh

clean: cleanup_script.sh
	./cleanup_script.sh

run: run_script.sh
	./run_script.sh

permissions: installation_script.sh cleanup_script.sh run_script.sh
	chmod +x $^
