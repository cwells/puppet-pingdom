class pingdom {
  $definitions = lookup('pingdom', Hash)

  notify { $definitions: }

  $defaults = {
    pingdom_account  => Sensitive($definitions['account']),
    pingdom_username => Sensitive($definitions['username']),
    pingdom_password => Sensitive($definitions['password']),
    pingdom_appkey   => $definitions['appkey']
  }

  create_resources('pingdom_user', $definitions['users'], $defaults)
  create_resources('pingdom_check', $definitions['checks'], $defaults)
}
