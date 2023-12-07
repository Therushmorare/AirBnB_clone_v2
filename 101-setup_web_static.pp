# web_setup.pp

# Install Nginx
package { 'nginx':
  ensure => 'installed',
}

# Create directory structure
file { '/data':
  ensure => 'directory',
}

file { '/data/web_static':
  ensure => 'directory',
}

file { '/data/web_static/releases':
  ensure => 'directory',
}

file { '/data/web_static/shared':
  ensure => 'directory',
}

file { '/data/web_static/releases/test':
  ensure => 'directory',
}

# Create a test index.html file
file { '/data/web_static/releases/test/index.html':
  content => 'This is a test',
}

# Create a symbolic link to set the current version
file { '/data/web_static/current':
  ensure  => 'link',
  target  => '/data/web_static/releases/test/',
  require => File['/data/web_static/releases/test'],
  before  => File['/etc/nginx/sites-available/default'],
}

# Set ownership
file { '/data':
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

# Add Nginx configuration for hbnb_static
file_line { 'nginx-hbnb-static':
  path    => '/etc/nginx/sites-available/default',
  line    => "location /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}",
  match   => '^}',
  after   => 'server_name localhost;',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Restart Nginx service
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => [Package['nginx'], File['/etc/nginx/sites-available/default']],
}
