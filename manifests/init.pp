class pingdom {
    $defaults = {
        'account_email' => hiera_hash('pingdom::account_email'),
        'user_email'    => hiera_hash('pingdom::user_email'),
        'password'      => hiera_hash('pingdom::password'),
        'appkey'        => hiera_hash('pingdom::appkey')
#        'log_level'     => hiera_hash('pingdom::log_level')
    }

    $users = hiera_hash('pingdom::users', {})
    $teams = hiera_hash('pingdom::teams', {})
    $checks = hiera_hash('pingdom::checks', {})

    create_resources('pingdom_user', $users, $defaults)
    create_resources('pingdom_team', $teams, $defaults)
    create_resources('pingdom_check', $checks, $defaults)
}

