class pingdom {
    $defaults = {
        'account_email' => lookup('pingdom::account_email', String),
        'user_email'    => lookup('pingdom::user_email', String),
        'password'      => lookup('pingdom::password', String),
        'appkey'        => lookup('pingdom::appkey', String)
#        'log_level'     => lookup('pingdom::log_level')
    }

    $users = lookup('pingdom::users', Hash, 'hash', {})
    $teams = lookup('pingdom::teams', Hash, 'hash', {})
    $checks = lookup('pingdom::checks', Hash, 'hash', {})

    notify { "${users}": }
    notify { "${teams}": }
    notify { "${checks}": }

    # create_resources('pingdom_user', $users, $defaults)
    # create_resources('pingdom_team', $teams, $defaults)
    # create_resources('pingdom_check', $checks, $defaults)
}

