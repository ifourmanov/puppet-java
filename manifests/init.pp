class java (  
  $source_url = "http://download.oracle.com/otn-pub/java/jdk/7u67-b01", 
  $java_major_version = 7, 
  $java_minor_version = 67,
  ) {
 
  $java_filename = "jdk-${java_major_version}u${java_minor_version}-linux-x64.rpm"

  # Download the jdk from location of choice
  include wget
  
  wget::fetch { 'jdk':
    source      => "${source_url}/$java_filename",
    no_cookies  => true,
    headers     => ['Cookie: oraclelicense=accept-securebackup-cookie;'],
    destination => "/usr/local/$java_filename",
    timeout     => 0,
    verbose     => false,
  }

  # Install the jdk
  package {'jdk':
    provider => rpm,
    ensure   => "1.${java_major_version}.0_${java_minor_version}-fcs",
    source   => "/usr/local/$java_filename",
    require  => Wget::Fetch['jdk'],
  }

  notify { "Major Version: $java_major_version, Minor Version: $java_minor_version": }

  # Configure JAVA_HOME globlly.
  file { '/etc/profile.d/java.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    content => "export JAVA_HOME=/usr/java/default",
  }

  # Change latest symlink
  file { '/usr/java/latest':
    ensure  => 'link',
    target  => "/usr/java/jdk1.${java_major_version}.0_${java_minor_version}" 
  }

  # Remove OpenJDK 6 devel
  package {'java-1.6.0-openjdk-devel':
    ensure  => absent,
  }
  ->
  # Remove OpenJDK 6
  package {'java-1.6.0-openjdk':
    ensure  => absent,
  }

  # Remove OpenJDK 7 devel
  package {'java-1.7.0-openjdk-devel':
    ensure  => absent,
  }
  ->
  # Remove OpenJDK 7
  package {'java-1.7.0-openjdk':
    ensure  => absent,
  }

}
