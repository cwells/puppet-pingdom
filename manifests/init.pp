class pingdom (
  $account,
  $username,
  $password,
  $appkey,
  $users = [],
  $checks = []
){

  Pingdom_user {
    pingdom_account  => Sensitive($account),
    pingdom_username => Sensitive($username),
    pingdom_password => Sensitive($password),
    pingdom_appkey   => $appkey
  }

  Pingdom_check {
    pingdom_account  => Sensitive($account),
    pingdom_username => Sensitive($username),
    pingdom_password => Sensitive($password),
    pingdom_appkey   => $appkey
  }

  create_resources(pingdom_user, $users)
  create_resources(pingdom_check, $checks)
}
