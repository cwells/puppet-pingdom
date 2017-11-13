Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check_base) do
    has_features :api_2_0

    accessorize
end