XDG_CONFIG_HOME ?= $(HOME)/.config
BINDIR ?= $(HOME)/.local/bin
SYSTEMD_USER_DIR ?= $(XDG_CONFIG_HOME)/systemd/user
WALLPAPERS_DIR ?= $(HOME)/Pictures/Wallpapers

INSTALL ?= install
INSTALL_DATA ?= $(INSTALL) -Dp -m 644
INSTALL_PROGRAM ?= $(INSTALL) -Dp -m 755
INSTALL_DIR ?= $(INSTALL) -d -m 755
SYSTEMCTL ?= systemctl

WALLPAPERS := $(wildcard wallpapers/*.jpg wallpapers/*.jpeg wallpapers/*.png wallpapers/*.webp)
SYSTEMD_UNITS := kanshi.service sway-session.target sway.service

SUBSYSTEMS := bin foot noctalia sway systemd wallpapers
INSTALL_TARGETS := $(addprefix install-,$(SUBSYSTEMS))
UNINSTALL_TARGETS := $(addprefix uninstall-,$(SUBSYSTEMS))

define daemon_reload
	@if [ -z "$(DESTDIR)" ] && command -v $(SYSTEMCTL) >/dev/null 2>&1; then \
		$(SYSTEMCTL) --user daemon-reload >/dev/null 2>&1 || true; \
	fi
endef

.PHONY: all help install uninstall $(INSTALL_TARGETS) $(UNINSTALL_TARGETS)

all: help

help: ## Show this help
	@echo "Targets:"
	@awk -F ':.*## ' '/^[a-zA-Z0-9_-]+:.*## / {printf "  %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Directories:"
	@echo "  BINDIR            = $(BINDIR)"
	@echo "  XDG_CONFIG_HOME   = $(XDG_CONFIG_HOME)"
	@echo "  SYSTEMD_USER_DIR  = $(SYSTEMD_USER_DIR)"
	@echo "  WALLPAPERS_DIR    = $(WALLPAPERS_DIR)"

install: $(INSTALL_TARGETS) ## Install all user files and configurations

uninstall: $(UNINSTALL_TARGETS) ## Remove all installed files

install-bin: ## Install sway-session script
	$(INSTALL_PROGRAM) bin/sway-session "$(DESTDIR)$(BINDIR)/sway-session"

uninstall-bin: ## Remove sway-session script
	$(RM) "$(DESTDIR)$(BINDIR)/sway-session"

install-foot: ## Install foot configuration
	$(INSTALL_DATA) foot/foot.ini "$(DESTDIR)$(XDG_CONFIG_HOME)/foot/foot.ini"

uninstall-foot: ## Remove foot configuration
	$(RM) "$(DESTDIR)$(XDG_CONFIG_HOME)/foot/foot.ini"

install-noctalia: ## Install noctalia configuration
	$(INSTALL_DATA) noctalia/config.toml "$(DESTDIR)$(XDG_CONFIG_HOME)/noctalia/config.toml"

uninstall-noctalia: ## Remove noctalia configuration
	$(RM) "$(DESTDIR)$(XDG_CONFIG_HOME)/noctalia/config.toml"

install-sway: ## Install sway configuration and environment
	$(INSTALL_DATA) sway/config "$(DESTDIR)$(XDG_CONFIG_HOME)/sway/config"
	$(INSTALL_DATA) sway/env "$(DESTDIR)$(XDG_CONFIG_HOME)/sway/env"

uninstall-sway: ## Remove sway configuration and environment
	$(RM) "$(DESTDIR)$(XDG_CONFIG_HOME)/sway/config" "$(DESTDIR)$(XDG_CONFIG_HOME)/sway/env"

install-systemd: ## Install user systemd services and targets
	$(INSTALL_DATA) -t "$(DESTDIR)$(SYSTEMD_USER_DIR)" $(addprefix systemd/,$(SYSTEMD_UNITS))
	$(INSTALL_DIR) "$(DESTDIR)$(SYSTEMD_USER_DIR)/sway-session.target.wants"
	ln -sf ../kanshi.service "$(DESTDIR)$(SYSTEMD_USER_DIR)/sway-session.target.wants/kanshi.service"
	$(daemon_reload)

uninstall-systemd: ## Remove user systemd services and targets
	$(RM) $(foreach u,$(SYSTEMD_UNITS),"$(DESTDIR)$(SYSTEMD_USER_DIR)/$(u)")
	$(RM) "$(DESTDIR)$(SYSTEMD_USER_DIR)/sway-session.target.wants/kanshi.service"
	-rmdir --ignore-fail-on-non-empty "$(DESTDIR)$(SYSTEMD_USER_DIR)/sway-session.target.wants" 2>/dev/null || true
	$(daemon_reload)

install-wallpapers: ## Install wallpapers
ifneq ($(strip $(WALLPAPERS)),)
	$(INSTALL_DATA) -t "$(DESTDIR)$(WALLPAPERS_DIR)" $(WALLPAPERS)
endif

uninstall-wallpapers: ## Remove wallpapers
ifneq ($(strip $(WALLPAPERS)),)
	$(RM) $(foreach wp,$(notdir $(WALLPAPERS)),"$(DESTDIR)$(WALLPAPERS_DIR)/$(wp)")
endif
