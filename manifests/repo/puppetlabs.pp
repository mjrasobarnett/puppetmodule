#"
# This module is used to setup the puppetlabs repos
# that can be used to install puppet.
#
class puppet::repo::puppetlabs(
  $repo_location = $puppet::params::repo_location,
  $repo_deps_location = $puppet::params::repo_deps_location,
) {

  if($::osfamily == 'Debian') {
    Apt::Source {
      location    => $repo_location,
      key         => '4BD6EC30',
      key_content => template('puppet/pgp.key'),
    }
    apt::source { 'puppetlabs':      repos => 'main' }
    apt::source { 'puppetlabs-deps': repos => 'dependencies' }
    } elsif $::osfamily == 'Redhat' {
      yumrepo { 'puppetlabs-deps':
        baseurl  => $repo_deps_location,
        descr    => 'Puppet Labs Dependencies $releasever - $basearch ',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
      }

      yumrepo { 'puppetlabs':
        baseurl  => $repo_location,
        descr    => 'Puppet Labs Products $releasever - $basearch',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
      }
    } else {
      fail("Unsupported osfamily ${::osfamily}")
    }
}
