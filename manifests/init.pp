class pingdom {
    $params = hiera_hash('pingdom')

    $defaults = {
        'account_email' => $params['account_email'],
        'user_email'    => $params['user_email'],
        'password'      => $params['password'],
        'appkey'        => $params['appkey']
    }

    create_resources('pingdom_user',  $params['users'],  $defaults)
    create_resources('pingdom_check', $params['checks'], $defaults)
}
