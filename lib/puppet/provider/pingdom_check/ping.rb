Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    has_features :host

    def host
        @check.fetch('host', :absent)
    end

    def do_apply
        attrs = update_attributes({
            :host => @resource[:host],
        })
        update_or_create 'ping', attrs
    end
end