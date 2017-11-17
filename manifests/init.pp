class pingdom (
    String $account_email = undef,
    String $user_email    = undef,
    String $password      = undef,
    String $appkey        = undef,
    Hash $users           = undef,
    Hash $checks          = undef
){
    $defaults = {
        'account_email' => pick($account_email, hiera_hash('pingdom::account_email')),
        'user_email'    => pick($user_email, hiera_hash('pingdom::user_email')),
        'password'      => pick($password, hiera_hash('pingdom::password')),
        'appkey'        => pick($appkey, hiera_hash('pingdom::appkey'))
    }

    $users = hiera_hash('pingdom::users')
    $checks = hiera_hash('pingdom::checks')

    create_resources('pingdom_user',  $users,  $defaults)
    create_resources('pingdom_check', $checks, $defaults)
}
