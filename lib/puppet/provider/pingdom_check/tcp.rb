Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    mk_resource_methods

    def do_apply
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtosend   => @resource[:stringtosend],
            :stringtoexpect => @resource[:stringtoexpect],
        })
        update_or_create 'tcp', attrs
    end
end