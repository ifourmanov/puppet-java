# Install oracle jdk and make it default one.
class java (
  $source_url = 'https://download.oracle.com/otn-pub/java/jdk/7u79-b15',
  $java_major_version = 7,
  $java_minor_version = 79,
  ) {

  $java_filename = "jdk-${java_major_version}u${java_minor_version}-linux-x64.rpm"
  $jdk_package_name = "jdk1.${java_major_version}.0_${java_minor_version}-1.${java_major_version}.0_${java_minor_version}-fcs.x86_64"

  include ::wget
  
  wget::fetch { 'jdk':
    source             => "${source_url}/${java_filename}",
    no_cookies         => true,
    headers            => ['Cookie: oraclelicense=accept-securebackup-cookie;'],
    destination        => "/usr/local/${java_filename}",
    timeout            => 0,
    nocheckcertificate => true,
    verbose            => false,
  }

  package {'java':
    ensure   => "1.${java_major_version}.0_${java_minor_version}-fcs",
    provider => apt,
    name     => 'jdk',
    source   => "/usr/local/${java_filename}",
    require  => Wget::Fetch['jdk'],
  }
  ->
  file { '/etc/profile.d/java.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => 'export JAVA_HOME=/usr/java/default',
  }
  ->
  exec { 'update-java-alternatives':
    path    => '/bin:/usr/bin:/usr/sbin',
    command => "alternatives --install /usr/bin/java java /usr/java/jdk1.${java_major_version}.0_${java_minor_version}/bin/java 200000",
    unless  => "[ `ls -l /etc/alternatives/java | awk '{print \$11}'` == '/usr/java/jdk1.${java_major_version}.0_${java_minor_version}/bin/java' ]"
  }
}
