class pingdom {
    $defaults = {
        'account_email' => hiera_hash('pingdom::account_email'),
        'user_email'    => hiera_hash('pingdom::user_email'),
        'password'      => hiera_hash('pingdom::password'),
        'appkey'        => hiera_hash('pingdom::appkey')
    }

    Pingdom_user {
        account_email => $defaults['account_email'],
        user_email    => $defaults['user_email'],
        password      => $defaults['password'],
        appkey        => $defaults['appkey']
    }

    Pingdom_check {
        account_email => $defaults['account_email'],
        user_email    => $defaults['user_email'],
        password      => $defaults['password'],
        appkey        => $defaults['appkey']
    }

    create_resources('pingdom_user',  hiera_hash('pingdom::users'),  $defaults)
    create_resources('pingdom_check', hiera_hash('pingdom::checks'), $defaults)
}

