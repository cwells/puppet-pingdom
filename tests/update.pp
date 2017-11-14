# Before running the tests, create a file named
# ~/.pingdom_credentials with the following YAML content:
#
#     ---
#     username: 'Your Pingdom username'
#     password: 'Your Pingdom password'
#     appkey: 'Your Pingdom appkey'
#
# Alternatively, just provide your credentials in the
# resource declarations below. Just be sure not to commit
# them to git ;-)
#
# At this point, from the top-level directory, you can run:
#     `export RUBYLIB=$PWD/lib ; puppet apply tests/update.pp`

Pingdom_check {
    credentials_file => '~/.pingdom_credentials',
    paused           => true
}

pingdom_check { "http://${facts['fqdn']}/check":
    ensure           => present,
    provider         => 'http',
    host             => $facts['fqdn'],
    url              => '/uptime',
    postdata         => Sensitive({
        username => 'admin',
        password => 'newp@ssw0rd'
    }),
    requestheaders   => Sensitive({
        'Content-Type' => 'x-application/json',
        'Auth-Token'   => 'XXX892N123456ZZZ'
    }),
    shouldcontain    => 'healthy',
    resolution       => 5,
    ipv6             => false,
    tags             => ['http', 'updated']
}

pingdom_check { "httpcustom://${facts['fqdn']}/status/pingdom.xml":
    ensure           => present,
    provider         => 'httpcustom',
    host             => $facts['fqdn'],
    url              => '/check/pingdom.xml',
    auth             => Sensitive('root:secret'),
    additionalurls   => [
        'http://www.domain1.com',
        'http://www.domain3.com'
    ],
    tags             => ['http', 'updated']
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    host             => $facts['fqdn'],
    expectedip       => '5.2.3.4',
    nameserver       => '8.8.8.8',
    tags             => ['dns', 'updated']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => $facts['fqdn'],
    tags             => ['ping', 'updated']
}

pingdom_check { "imap://${facts['fqdn']}":
    ensure         => present,
    provider       => 'imap',
    host           => $facts['fqdn'],
    port           => 993,
    stringtoexpect => 'Courier IMAP v3',
    encryption     => true,
    tags           => ['imap', 'updated']
}

pingdom_check { "pop3://${facts['fqdn']}":
    ensure         => present,
    provider       => 'pop3',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Courier POP3 v3',
    encryption     => true,
    paused         => true,
    tags           => ['pop3', 'updated']
}

pingdom_check { "smtp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'smtp',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Postfix SMTP Server',
    encryption     => true,
    tags           => ['smtp', 'updated']
}

pingdom_check { "tcp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'tcp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'hello',
    stringtoexpect => 'howdy',
    encryption     => true,
    paused         => true,
    tags           => ['tcp', 'updated']
}

pingdom_check { "udp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'udp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'hello',
    stringtoexpect => 'howdy',
    encryption     => true,
    tags           => ['udp', 'updated']
}
