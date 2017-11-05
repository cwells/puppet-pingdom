Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    has_features :host

    def host
        begin
            @check['type']['ping']['hostname']
        rescue => exception
            :absent
        end
    end

    def host=(value)
        @property_hash[:host] = value
    end

    def do_apply
        update_or_create :ping, apply_properties({
            :host => fetch(:host)
        })
    end
end