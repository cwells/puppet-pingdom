class pingdom {
  $definitions = lookup('pingdom', Hash)

  $defaults = {
    'account_email' => Sensitive($definitions['account_email']),
    'user_email'    => Sensitive($definitions['user_email']),
    'password'      => Sensitive($definitions['password']),
    'appkey'        => $definitions['appkey']
  }

  create_resources('pingdom_user', $definitions['users'], $defaults)
  create_resources('pingdom_check', $definitions['checks'], $defaults)
}
