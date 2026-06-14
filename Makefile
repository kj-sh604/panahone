PREFIX ?= $(HOME)/.local

install:
	mkdir -p $(PREFIX)/bin
	mkdir -p $(HOME)/.cache/panahone
	install -Dm755 src/panahone $(PREFIX)/bin/panahone
	cp -n src/panahone.png $(HOME)/.cache/panahone/panahone.png

remove:
	rm -f $(PREFIX)/bin/panahone
	rm -rf $(HOME)/.cache/panahone

.PHONY: install remove
