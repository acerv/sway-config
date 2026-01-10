# Desktop configuration

This is an automatic configuration for the sway desktop, based on the
[openSUSEsway](https://github.com/openSUSE/openSUSEway) project and using
[meson](https://mesonbuild.com/index.html) as build system.

It installs all configuration to automatically have a working sway desktop,
setting up systemd applications without any need of having a login manager.
Run the desktop environment with `sway-session` command.

Required applications:

- sway
- swayidle
- swaylock
- swaync
- fuzzel
- foot
- waybar
- kanshi

To install the configuration:

```
meson setup build
cd build && meson install
```
