class ssh {
  if $ssh_disabled == 'false' {
    file {'copy-ssh-folder':
      ensure        => 'directory',
      recurse       => true,
      path          => '/home/vagrant/.ssh',
      owner         => 'vagrant',
      group         => 'vagrant',
      mode          => 0600,
      sourceselect  => 'all',
      source        => '/tmp/.ssh',
    }

    file { '/tmp/known_hosts.sh':
      ensure => file,
      source => '/vagrant/puppet/modules/ssh/files/known_hosts.sh',
      mode => 755,
    }

    exec { 'add-known-hosts':
      command => '/tmp/known_hosts.sh',
      provider => 'shell',
      user => 'root',
      require => [
        File['/tmp/known_hosts.sh'],
        File['copy-ssh-folder']
      ],
    }
  }
}
