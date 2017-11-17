class pingdom {
    $defaults = {
        'account_email' => hiera('pingdom::account_email'),
        'user_email'    => hiera('pingdom::user_email'),
        'password'      => hiera('pingdom::password'),
        'appkey'        => hiera('pingdom::appkey')
    }

    create_resources('pingdom_user',  hiera_hash('pingdom::users'),  $defaults)
    create_resources('pingdom_check', hiera_hash('pingdom::checks'), $defaults)
}
