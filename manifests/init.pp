class ssh {
  if $ssh == 'true' {
    file {'copy-authorized-keys':
      ensure        => 'file',
      path          => '/tmp/authorized_keys',
      owner         => 'vagrant',
      group         => 'vagrant',
      replace       => true,
      source        => '/home/vagrant/.ssh/authorized_keys',
    }

    file {'copy-ssh-folder':
      ensure        => 'directory',
      recurse       => true,
      path          => '/home/vagrant/.ssh',
      owner         => 'vagrant',
      group         => 'vagrant',
      mode          => 0600,
      replace       => true,
      sourceselect  => 'all',
      source        => '/tmp/.ssh',
      purge         => true,
      require       => File['copy-authorized-keys'],
    }

    file { '/tmp/known_hosts.sh':
      ensure => file,
      source => '/vagrant/puppet/vendor/ssh/files/known_hosts.sh',
      mode => 755,
    }

    exec {'add-authorized-key':
      command => '/bin/bash -c \'cat /tmp/authorized_keys >> /home/vagrant/.ssh/authorized_keys\'',
      require => File['copy-ssh-folder'],
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

    file {'copy-ssh-folder-to-root':
      ensure        => 'directory',
      recurse       => true,
      path          => '/root/.ssh',
      owner         => 'root',
      group         => 'root',
      mode          => 0600,
      replace       => true,
      sourceselect	=> 'all',
      source        => '/home/vagrant/.ssh',
      purge         => true,
      require       => [
        File['copy-authorized-keys'],
        File['copy-ssh-folder'],
        Exec['add-authorized-key'],
        Exec['add-known-hosts']
      ],
    }
  }
}
