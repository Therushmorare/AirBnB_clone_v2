# Update and upgrade the system
exec { 'apt-update-upgrade':
  command => '/usr/bin/apt-get update && /usr/bin/apt-get -y upgrade',
  path    => '/usr/bin',
}

package { 'nginx':
  ensure => 'installed',
}

file { '/data/web_static/releases/test':
  ensure => 'directory',
}

file { '/data/web_static/shared':
  ensure => 'directory',
}

file { '/data/web_static/releases/test/index.html':
  content => 'This is a test',
}

file { '/data/web_static/current':
  ensure  => 'link',
  target  => '/data/web_static/releases/test/',
  require => File['/data/web_static/releases/test'],
}

exec { 'set-ownership':
  command => '/bin/chown -hR ubuntu:ubuntu /data/',
  path    => '/bin',
}

file_line { 'nginx-hbnb-static':
  path    => '/etc/nginx/sites-available/default',
  line    => "location /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}",
  match   => '^}',
  after   => 'server_name localhost;',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Start Nginx service
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}
