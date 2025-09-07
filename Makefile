#
#  Copyright (C) 2013 Juan Ramon Castan Guillen <juanramoncastan@yahoo.es>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
# ----------------------------------------------------------------------

# ###########      aptkey-gpg Makefile     ###########################
# Version: 0.4

#####  BUILD = "../package-name_version_architecture" given from "debianizador" script
PREFIX = /usr
BIN_PATH = /bin


test:
	@ echo User: $(USER)


install: test
	@ echo "install: binary "
	mkdir -p $(BUILD)$(PREFIX)$(BIN_PATH)
	cp .$(BIN_PATH)/* $(BUILD)$(PREFIX)$(BIN_PATH)
	@ echo

	
uninstall: test
	@ echo
	@ echo "uninstall: binaries"
	@ for F in $$( ls ./bin ) ; do \
		if [ -f $(BUILD)$(PREFIX)$(BIN_PATH)/$${F} ] ; then \
			echo Removing $(BUILD)$(PREFIX)$(BIN_PATH)/$${F} && \
			rm $(BUILD)$(PREFIX)$(BIN_PATH)/$${F} ; \
		fi ; \
	done
	@ echo

