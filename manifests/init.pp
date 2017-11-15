class pingdom {
  $definitions = lookup('pingdom', Hash)

  $defaults = {
    'account'  => Sensitive($definitions['account']),
    'username' => Sensitive($definitions['username']),
    'password' => Sensitive($definitions['password']),
    'appkey'   => $definitions['appkey']
  }

  create_resources('pingdom_user', $definitions['users'], $defaults)
  create_resources('pingdom_check', $definitions['checks'], $defaults)
}
