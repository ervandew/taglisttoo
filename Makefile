SHELL=/bin/bash

all: dist

dist:
	@rm taglisttoo.vmb 2> /dev/null || true
	@vim -c 'r! git ls-files autoload doc plugin' \
		-c '$$,$$d _' -c '%MkVimball taglisttoo .' -c 'q!'

clean:
	@rm -R build 2> /dev/null || true
