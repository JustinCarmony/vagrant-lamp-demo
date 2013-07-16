# Setting the path for any command operations
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

# We want to update our aptitude repositories before doing anything else
class apt-get-update {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }
}

$core_tools_packages = ["build-essential", "imagemagick", "sshfs", "git-core", "subversion", "htop", "vim", "curl"]

class core-tools {
  package { $core_tools_packages: 
  	ensure => "installed", 
  	require => Class["apt-get-update"] 
  }
  
  file { "/root/.bash_aliases":
    path => "/root/.bash_aliases",
    source => '/puppet_files/root/.bash_aliases',
    mode => 700
  }

  # Add PPAs for PHP 5.4
  apt::ppa { "ppa:ondrej/php5": }
}

class apache2 {
  package { "apache2":
    ensure => present,
    require => Class["core-tools"]
  }

  exec { "a2enmod rewrite":
    unless => "ls /etc/apache2/mods-enabled/rewrite.load",
    command => "a2enmod rewrite",
    notify => Service["apache2"]
  }

  service { "apache2":
    ensure => running,
    require => Package["apache2"],
  }

  # Setup apache config files
  file { "/etc/apache2/apache2.conf" :
    path => "/etc/apache2/apache2.conf",
    source => '/puppet_files/etc/apache2/apache2.conf',
    require => Package["apache2"],
    notify => Service["apache2"]
  }

  file { "/etc/apache2/sites-available/default" :
    path => "/etc/apache2/sites-available/default",
    source => '/puppet_files/etc/apache2/sites-available/default',
    require => Package["apache2"],
    notify => Service["apache2"]
  }
}

$php5_packages = ["php5", "libapache2-mod-php5", "php5-cli","php5-dev", "php-pear", "php5-curl","php5-imagick","php5-memcache","php5-mysql","php5-xdebug"]

class php5 { 
  
  package { $php5_packages: ensure => "latest", require => Class["core-tools"] }
  #file { "/etc/php5/apache2/php.ini":
  #  path => "/etc/php5/apache2/php.ini",
  #  source => "/puppet-files/etc/php5/apache2/php.ini",
  #  require => [ Package["apache2"] ],
  #  notify => Service["apache2"]
  #
  #}
  #file { "/etc/php5/cli/php.ini":
  #  path => "/etc/php5/cli/php.ini",
  #  source => "/puppet-files/etc/php5/cli/php.ini",
  #  require => Exec["pecl install mongo"]
  #
  #}
  #
  #exec { "pecl install mongo":
  #  unless => "ls /usr/lib/php5/20100525/mongo.so",
  #  command => "pecl update-channels && pecl install mongo",
  #  require => Package[$php5_packages]
  #}
  #
  #exec { "install composer":
  #  unless => "ls /usr/local/bin/composer",
  #  command => '/bin/sh -c "cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer"',
  #  require => Package[$php5_packages]
  #
  #}
}

$mysql_packages = ["mysql-server-5.5", "mysql-client-5.5"]

class mysql {
  package { $mysql_packages: ensure => "installed", require => Class["core-tools"] }

}

# Which Classes to Include
include apt-get-update
include core-tools
include apache2
include php5
include mysql