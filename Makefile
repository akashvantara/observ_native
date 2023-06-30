SHELL_FILES=installation_script.sh cleanup_script.sh run_script.sh kill_script.sh
YAML_FILES=loki-local-config.yaml config.yaml
OTHER_FILES=Makefile commands.txt

install: installation_script.sh
	./$^

clean: cleanup_script.sh
	./$^

run: run_script.sh
	./$^

kill: kill_script.sh
	./$^

tar: $(SHELL_FILES) $(YAML_FILES) $(OTHER_FILES)
	tar cvf observ_native.tar.xz $^

permissions: $(SHELL_FILES)
	chmod +x $^

remove-permissions:  $(SHELL_FILES)
	chmod -x $^
