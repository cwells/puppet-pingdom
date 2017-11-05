# puppet-pingdom
Puppet type and provider for Pingdom API. 

Still a work-in-progress.

#### Credentials:
```puppet
Pingdom_check {
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey
}
```
#### HTTP check:
```
pingdom_check { "http://${facts['fqdn']}/check":
    ensure     => present,
    provider   => 'http',
    host       => $facts['fqdn'],
    url        => '/check',
    paused     => true,
    resolution => 5,
    tags       => ['test', 'http']
}
```
#### DNS check:
```puppet
pingdom_check { 'dns://hq.company.com':
    ensure     => present,
    provider   => 'dns',
    hostname   => 'hq.company.com',
    expectedip => '1.2.3.4',
    nameserver => '8.8.8.8',
    paused     => true,
    tags       => ['test', 'dns']
}
```
#### Ping check:
```puppet
pingdom_check { 'ping://www.google.com':
    ensure   => present,
    provider => 'ping',
    host     => 'www.google.com',
    paused   => true,
    tags     => ['test', 'ping']
}
```
### Status
- Check API
  - create works
  - delete works
  - update works 
  - properties work partially
      - scalar properties work
      - structured tags property works
      - other structured properties TBD
- User API _TBD_. Currently blocked on [this issue](https://github.com/cwells/puppet-pingdom/issues/2)
- Team API _TBD_. Currently blocked on [the same thing](https://github.com/cwells/puppet-pingdom/issues/2)

### Known issues
- `puppet resource pingdom_check` command will likely never work, as it's not possible to collect authenticated resources inside of `self.instances`, since it's a class method and doesn't have access to instantiation-time parameters such as credentials.
  
