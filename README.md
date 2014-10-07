Java Puppet Module.

This is meant to be used as a dependency and in conjunction with Hiera.
The rpms are assumed available at a preferred location.


Supported OS: Redhat.


## Using from Github / source

### With librarian

If you use [librarian-puppet](https://github.com/rodjek/librarian-puppet), add
the following to your `Puppetfile`:

```ruby
mod "java",
  :git => "git@github.com:cakesolutions/puppet-java.git",
  :ref => "0.0.3"
```

Hiera property required:

```
java::source_url: "http://download.oracle.com/otn-pub/java/jdk/7u51-b13"
```

