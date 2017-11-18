class pingdom {
    $defaults = {
        'account_email' => lookup('pingdom::account_email'),
        'user_email'    => lookup('pingdom::user_email'),
        'password'      => lookup('pingdom::password'),
        'appkey'        => lookup('pingdom::appkey')
#        'log_level'     => lookup('pingdom::log_level')
    }

    $users = lookup('pingdom::users', {})
    $teams = lookup('pingdom::teams', {})
    $checks = lookup('pingdom::checks', {})

    notify { "${users}": }
    notify { "${teams}": }
    notify { "${checks}": }

    # create_resources('pingdom_user', $users, $defaults)
    # create_resources('pingdom_team', $teams, $defaults)
    # create_resources('pingdom_check', $checks, $defaults)
}

