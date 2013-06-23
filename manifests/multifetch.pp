################################################################################
# Definition: wget::fetch
#
# This class will download files from the internet.  You may define a web proxy
# using $http_proxy if necessary. Username must be provided. And the user's
# password must be stored in the password variable within the .wgetrc file.
#
################################################################################
define wget::multifetch(
  $no_check_cert = false,
  $destination,
  $http_proxy         = undef,
  $password           = undef,
  $source_base,
  $names,
  $timeout            = "0",
  $user               = undef,
) {
  if $http_proxy {
    $environment = [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy", "WGETRC=/tmp/wgetrc-$name" ]
  }
  elsif password {
    $environment = [ "WGETRC=/tmp/wgetrc-$name" ]
    file { "/tmp/wgetrc-$name":
      before  => Exec[$names],
      content => "password=$password",
      mode => 600,
      owner => root,
    }
  } else {
    $environment = []
  }
  
  if $no_check_cert {
    $real_no_check_cert = ' --no-check-certificate'
  } 
  else {
    $real_no_check_cert = ''
  }
  
  wget::multifetch::execdefine { $names:
    destination         => $destination,
    environment         => $environment,
    real_no_check_cert  => $real_no_check_cert,
    source_base         => $source_base,
    user                => $user, 
  }
}


define wget::multifetch::execdefine(
  $destination,
  $environment,
  $real_no_check_cert,
  $source_base,
  $user,
) {
  $filename = url_parse("$source_base/$title", filename)

  exec { $title:
    command => "/usr/bin/wget $real_no_check_cert--user=$user --output-document=$destination/$filename $source_base/$title",
    timeout => $timeout,
    unless => "/usr/bin/test -s $destination/$title",
    environment => $environment,
  }
}
