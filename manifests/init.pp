class pingdom (
    String $account_email,
    String $user_email,
    String $password,
    String $appkey,
    Hash $users  = {},
    Hash $checks = {}
){

    $defaults = {
        'account_email' => $account_email,
        'user_email'    => $user_email,
        'password'      => $password,
        'appkey'        => $appkey
    }

    create_resources('pingdom_user',  $users,  $defaults)
    create_resources('pingdom_check', $checks, $defaults)
}
