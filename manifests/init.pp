class pingdom {
    $account_email = lookup('pingdom::account_email', String, 'first', false)

    $common = {
        'user_email' => lookup('pingdom::user_email', String, 'first'),
        'password'   => lookup('pingdom::password', String, 'first'),
        'appkey'     => lookup('pingdom::appkey', String, 'first')
    }

    $defaults = $account_email ? {
        default => merge($common, {'account_email' => $account_email}),
        false   => $common
    }

    $users = lookup('pingdom::users', Hash, 'hash', {})
    $teams = lookup('pingdom::teams', Hash, 'hash', {})
    $checks = lookup('pingdom::checks', Hash, 'hash', {})

    pingdom_user { 'SRE PagerDuty':
        account_email => $account_email,
        user_email    => $common['user_email'],
        password      => $common['password'],
        appkey        => $common['appkey'],
        contact_targets => {
            email => 'sre@focusvision.com'
        }
    }

    # create_resources('pingdom_user', $users, $defaults)
    # create_resources('pingdom_team', $teams, $defaults)
    # create_resources('pingdom_check', $checks, $defaults)
}

