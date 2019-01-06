# Copyright © 2019 ARClab, Lionel Riem - https://arclab.ch/
#
# Use of this source code is governed by the MIT license that can be found in
# the LICENSE file.

# Stop if Windows detected
ifeq ($(OS),Windows_NT)
    $(error Windows is not supported)
endif

# Stop if Ubuntu detected
UBUNTU := $(shell if [ -e /etc/lsb-release ]; then . /etc/lsb-release; echo $$DISTRIB_ID; fi)
ifeq ($(UBUNTU),Ubuntu) 
    $(error Ubuntu is not supported as it already has a comparable motd mechanism. The scripts of this software are compatible with it and require a manual installation in /etc/update-motd.d as well as some adaptation)
endif

# Get version from Git
VERSION := $(shell sh -c 'git describe --always --tags --long --dirty 2>/dev/null || echo undefined')

# If no prefix, set it
ifeq ($(PREFIX),)

    # Get the OS
    KERNEL := $(shell sh -c 'uname 2>/dev/null || echo Unknown')

    # FreeBSD lands in /usr/local/, / otherwise
    ifeq ($(KERNEL),FreeBSD)
        PREFIX := /usr/local
        CONFIG := \/usr\/local

    else
        PREFIX := /usr
        CONFIG := 
    endif
endif

# Check if cron.d exists
CROND := $(shell if [ -d /etc/cron.d ]; then echo 1; else echo 0; fi)

# Where to put the work we do
ifeq ($(WORKDIR),)
    WORKDIR := ./work
endif

# Check if a previous installation exists
UPDATE := $(shell if [ -e $(PREFIX)/bin/update-motd ]; then echo 1; else echo 0; fi)

# Check if build job has already run
ISBUILT := $(shell if [ -e $(WORKDIR)/built ]; then echo 1; else echo 0; fi)

# Default target is build
all: build


build:
	@echo "Preparing version $(VERSION) for $(KERNEL)."
ifeq ($(CROND),1)
	@echo "- /etc/cron.d exists"
else
	@echo "- No compatible cron.d folder found, manual setup of cron needed."
endif
	@echo ""

	@echo "Preparing work environment"
	@install -d $(WORKDIR)/bin
ifeq ($(UPDATE),0)
	@install -d $(WORKDIR)/etc/update-motd.d
	@install -d $(WORKDIR)/etc/cron.d
endif

	@echo "Preparing main script"
	@sed -e 's/%%VERSION%%/$(VERSION)/g' ./update-motd | sed -e 's/%%PREFIX%%/$(CONFIG)/g' > $(WORKDIR)/bin/update-motd

ifeq ($(UPDATE),0)
	@echo "Preparing the subscripts"
	@sed -e 's/%%PREFIX%%/$(CONFIG)/g' ./00-header > $(WORKDIR)/etc/update-motd.d/00-header
	@sed -e 's/%%PREFIX%%/$(CONFIG)/g' ./10-baseinfo > $(WORKDIR)/etc/update-motd.d/10-baseinfo
	@sed -e 's/%%PREFIX%%/$(CONFIG)/g' ./20-information > $(WORKDIR)/etc/update-motd.d/20-information
	@sed -e 's/%%PREFIX%%/$(CONFIG)/g' ./30-changelog > $(WORKDIR)/etc/update-motd.d/30-changelog
	@sed -e 's/%%PREFIX%%/$(CONFIG)/g' ./99-disclaimer > $(WORKDIR)/etc/update-motd.d/99-disclaimer

	@echo "Preparing example files"
	@cp ./header.txt $(WORKDIR)/etc/update-motd.d/
	@cp ./information.txt $(WORKDIR)/etc/update-motd.d/
	@cp ./disclaimer.txt $(WORKDIR)/etc/update-motd.d/

	@echo "Preparing the configuration file"
	@sed -e 's/%%PREFIX%%/$(CONFIG)/g' ./update-motd.conf > $(WORKDIR)/etc/update-motd.conf

	@echo "Preparing the crontab file"
	@cp ./update-motd.cron $(WORKDIR)/etc/cron.d/update-motd
endif

	@touch $(WORKDIR)/built
	@echo ""

ifeq ($(UPDATE),0)
	@echo "Build is complete. Proceed with installation with make install."
else
	@echo "Build is complete. As this seems to be an update, use make update to update it."
endif


install:
ifeq ($(ISBUILT),0)
	$(error Nothing to install. Run make build first)
endif
ifeq ($(UPDATE),1)
	$(error update-motd is already installed on this system. Use make update instead)
endif

	@echo "Installing script..."
	@install -m 755 $(WORKDIR)/bin/update-motd $(PREFIX)/bin/update-motd

	@echo "Installing configuration file..."
	@install -m 755 $(WORKDIR)/etc/update-motd.conf $(CONFIG)/etc/update-motd.conf

	@echo "Installing subscript and related files..."
	@cp -r $(WORKDIR)/etc/update-motd.d $(CONFIG)/etc/
	@chown -R root $(CONFIG)/etc/update-motd.d
	@chmod -R 755 $(CONFIG)/etc/update-motd.d

	@echo "Installating crontab file..."
ifeq ($(CROND),1)
	@install -m 755 $(WORKDIR)/etc/cron.d/update-motd /etc/cron.d/update-motd
else
	@echo "WARNING: Unable to install contab file as no cron.d folder was found. Install it manually!"
endif


	@echo ""
	@echo "Installation complete!"
	@echo "Get started by editing $(CONFIG)/etc/update-motd.conf to suit your needs."
	@echo "Update *.txt files in $(CONFIG)/etc/update-motd.d as needed too."

update:
ifeq ($(ISBUILT),0)
	$(error Nothing to update. Run make build first)
endif
ifeq ($(UPDATE),0)
	$(error update-motd is not installed on this system. Use make install instead)
endif

	@echo "Updating script..."
	@install -m $(WORKDIR)/bin/update-motd $(PREFIX)/bin/update-motd
	@echo "Done."


clean:
	@echo "Cleaning by deleting work directory."
	@rm -rf ${WORKDIR}

.PHONY: build install update clean