class pingdom {
    $account_email = lookup('pingdom::account_email', String, 'hash', false)

    $common = {
        'user_email' => lookup('pingdom::user_email', String, 'hash'),
        'password'   => lookup('pingdom::password', String, 'hash'),
        'appkey'     => lookup('pingdom::appkey', String, 'hash')
    }

    $defaults = $account_email ? {
        default => merge($common, {'account_email' => $account_email}),
        false   => $common
    }

    $users = lookup('pingdom::users', Hash, 'deep', {})
    $teams = lookup('pingdom::teams', Hash, 'deep', {})
    $checks = lookup('pingdom::checks', Hash, 'deep', {})

    notify {"${checks}":}

    create_resources('pingdom_user', $users, $defaults)
    create_resources('pingdom_team', $teams, $defaults)
    create_resources('pingdom_check', $checks, $defaults)
}

