install_data([
    'kanshi.service',
    'sway-session.target',
    'sway.service',
    'swayidle.service',
  ],
  install_dir: '/usr/lib/systemd/user/',
)

run_command(
    'systemctl',
    '--user',
    'add-wants',
    'sway-session.target',
    'kanshi.service',
    'swaync.service',
    'swayidle.service',
    check: true)
