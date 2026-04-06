install_data([
    'kanshi.service',
    'sway-session.target',
    'sway.service',
    'swayidle.service',
  ],
  install_dir: '/usr/lib/systemd/user/',
)

foreach unit : ['kanshi.service', 'swaync.service', 'swayidle.service']
  install_symlink(
    unit,
    pointing_to: '/usr/lib/systemd/user/' + unit,
    install_dir: '/usr/lib/systemd/user/sway-session.target.wants',
  )
endforeach
