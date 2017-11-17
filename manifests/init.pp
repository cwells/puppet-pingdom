class pingdom {
    $account_email = hiera('pingdom::account_email'),
    $user_email    = hiera('pingdom::user_email'),
    $password      = hiera('pingdom::password'),
    $appkey        = hiera('pingdom::appkey')

    Pingdom_user {
        account_email => $account_email,
        user_email    => $user_email,
        password      => $password,
        appkey        => $appkey
    }

    Pingdom_check {
        account_email => $account_email,
        user_email    => $user_email,
        password      => $password,
        appkey        => $appkey
    }

    create_resources('pingdom_user',  hiera_hash('pingdom::users'))
    create_resources('pingdom_check', hiera_hash('pingdom::checks'))
}

