SHELL_FILES=installation_script.sh cleanup_script.sh run_script.sh kill_script.sh

install: installation_script.sh
	./$^

clean: cleanup_script.sh
	./$^

run: run_script.sh
	./$^

kill: kill_script.sh
	./$^

permissions: $(SHELL_FILES)
	chmod +x $^

remove-permissions:  $(SHELL_FILES)
	chmod -x $^

