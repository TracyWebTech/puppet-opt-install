puppet-opt-install
==================

PROVIDES A INSTALLER TO OPT APPLICATIONS

PARAMS:
* source = Source to get app. Accept: HTTP, FTP or Puppet File server
* compress_type = tgz|tar.gz|tar|zip. Defaults to tgz. 
** If using zip, you need package unzip installed!
* tmp_dir = path to temp dir. Defaults to /tmp

Usage: 
Using ftp or http source
install_opt::install { "source": 
  $source => "http|ftp://url_to_source"
}

Using puppet server source
install_opt::install { "source": 
  $source => "puppet:///path_to_source"
}