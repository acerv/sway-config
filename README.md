# Desktop configuration

This is an automatic configuration for the sway desktop, based on the
[openSUSEsway](https://github.com/openSUSE/openSUSEway) project.

It installs all configuration to automatically have a working sway desktop,
setting up systemd applications without any need of having a login manager.
Run the desktop environment with `sway-session` command.

Required applications:

- sway
- noctalia
- foot
- kanshi

To install the configuration in your home directory:

```sh
make install
```

Make sure `~/.local/bin` is in your `PATH` so `sway-session` can be launched
directly from a TTY.

You can also install or uninstall specific subsystems:

```sh
make install-bin         # Install sway-session script
make install-sway        # Install sway config and environment
make install-foot        # Install foot terminal configuration
make install-noctalia    # Install noctalia shell configuration
make install-systemd     # Install user systemd services and targets
make install-wallpapers  # Install wallpapers
```

To uninstall:

```sh
make uninstall
# Or per-subsystem, e.g.: make uninstall-sway
```
