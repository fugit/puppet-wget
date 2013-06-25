################################################################################
# Definition: wget::fetch
#
# This class will download files from the internet.  You may define a web proxy
# using $http_proxy if necessary. Username must be provided. And the user's
# password must be stored in the password variable within the .wgetrc file.
#
################################################################################
define wget::multifetch(
  $destination,
  $names,
  $no_check_cert = false,
  $http_proxy         = undef,
  $http_user          = undef,
  $http_password      = undef,
  $source_base,
  $script_user        = undef,
  $timeout            = "0",
) {
  if $http_proxy {
    $environment = [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy", "WGETRC=/tmp/wgetrc-$name" ]
  }
  elsif $http_password {
    $environment = [ "WGETRC=/tmp/wgetrc-$name" ]
    file { "/tmp/wgetrc-$name":
      before  => Exec[$names],
      content => "password=$http_password",
      mode => 600,
      owner => $script_user,
    }
  } else {
    $environment = []
  }
  
  if $no_check_cert {
    $real_no_check_cert = '--no-check-certificate '
  } 
  else {
    $real_no_check_cert = ''
  }
  
  wget::multifetch::execdefine { $names:
    destination         => $destination,
    environment         => $environment,
    http_user           => $http_user, 
    real_no_check_cert  => $real_no_check_cert,
    script_user         => $script_user,
    source_base         => $source_base,
  }
}


define wget::multifetch::execdefine(
  $destination,
  $environment,
  $http_user,
  $real_no_check_cert,
  $script_user,
  $source_base,
) {
  $filename = url_parse("$source_base/$title", filename)

  exec { $title:
    command     => "/usr/bin/wget $real_no_check_cert--user=$http_user --output-document=$destination/$filename $source_base/$title",
    timeout     => $timeout,
    unless      => "/usr/bin/test -s $destination/$filename",
    user        => $script_user,
    environment => $environment,
  }
}
