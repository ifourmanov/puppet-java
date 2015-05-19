class java (
  $source_url = "https://download.oracle.com/otn-pub/java/jdk/7u51-b13",
  $java_major_version = 7,
  $java_minor_version = 51,
  ) {

  $java_filename = "jdk-${java_major_version}u${java_minor_version}-linux-x64.rpm"
  $jdk_package_name = "jdk1.${java_major_version}.0_${java_minor_version}-1.${java_major_version}.0_${java_minor_version}-fcs.x86_64"

  include ::wget
  
  wget::fetch { 'jdk':
    source              => "${source_url}/$java_filename",
    no_cookies          => true,
    headers             => ['Cookie: oraclelicense=accept-securebackup-cookie;'],
    destination         => "/usr/local/$java_filename",
    timeout             => 0,
    nocheckcertificate  => true,
    verbose             => false,
  }

  package {'java-1.6.0-openjdk':
    ensure   => absent,
  }

  package {'java-1.6.0-openjdk-devel':
    ensure  => absent,
  }

  package {'java-1.7.0-openjdk':
    ensure   => absent,
  }

  package {'java-1.7.0-openjdk-devel':
    ensure  => absent,
  }

  package {'java':
    name     => "$jdk_package_name"
    provider => rpm,
    ensure   => installed,
    source   => "/usr/local/$java_filename",
    require  => Wget::Fetch['jdk'],
  }
  ->
  file { '/etc/profile.d/java.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    content => "export JAVA_HOME=/usr/java/default",
  }
  ->
  file { '/usr/java/latest':
    ensure  => 'link',
    target  => "/usr/java/jdk1.${java_major_version}.0_${java_minor_version}" 
  }
}
