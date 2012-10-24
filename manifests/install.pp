# PARAMS:
# * source = Source to get app. Accept: HTTP, FTP or Puppet File server
# * compress_type = tgz|tar.gz|tar|zip. Defaults to tgz. 
# ** If using zip, you need package unzip installed!
# * tmp_dir = path to temp dir. Defaults to /tmp
# 
# Usage: 
# Using ftp or http source
# install_opt::install { "source": 
#   $source => "http|ftp://url_to_source"
# }
# 
# Using puppet server source
# install_opt::install { "source": 
#   $source => "puppet:///path_to_source"
# }


define install_opt::install (
  $source,
  $compress_type = 'tgz',
  $tmp_dir = '/tmp'
) {

  $source_split = split($source, '/')
  $protocol = $source_split[0]
  $file_name = $source_split[-1]

  if $protocol == 'http:' or $protocol == 'ftp:' {

    Exec {
      path => ['/usr/bin', '/bin']
    }

    if !defined(Package['wget']) {
      package { 'wget':
        ensure => installed
      }
    }

    exec { "get-source-${file_name}":
      command => "wget ${source} -qP /tmp",
      require => Package["wget"],
    }
    file { "file-source-${file_name}":
      ensure => present,
      path => '/tmp/${file_name}',
      require => Exec["get-source-${file_name}"]
    }
  } elsif $protocol == 'puppet:'  {
    file { "file-source-${file_name}":
      ensure =>  present,
      path => '/tmp/${file_name}',
      source => $source
    }
  }

  case $compress_type {
    'tgz','tar.gz': { $command = "tar -xzf /tmp/${file_name} -C /opt" }
    'tar': { $command = "tar -xf /tmp/${file_name} -C /opt" }
    'zip': { $command = "unzip /tmp/${file_name} -d /opt"  }
  }

  exec { "unpack-source-${file_name}":
    command => $command,
    require => File["file-source-${file_name}"],
  }

}