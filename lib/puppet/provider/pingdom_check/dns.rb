Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :api) do
    has_features :hostname, :expectedip, :nameserver

    def update_or_create
        params = {
            :name                     => @resource[:name],
            :host                     => @resource[:hostname],
            :expectedip               => @resource[:expectedip],
            :nameserver               => @resource[:nameserver],
            :paused                   => @resource[:paused],
            :resolution               => @resource[:resolution],
            :ipv6                     => @resource[:ipv6],
            :sendnotificationwhendown => @resource[:sendnotificationwhendown],
            :notifyagainevery         => @resource[:notifyagainevery],
            :notifywhenbackup         => @resource[:notifywhenbackup],
            :tags                     => @resource[:tags].sort.join(','),
            :probe_filters            => @resource[:probe_filters].sort.join(','),
            :userids                  => @resource[:userids].sort.join(','),
            :teamids                  => @resource[:teamids].sort.join(','),
            # :integrationids           => @resource[:integrationids].sort.join(',')
        }
        if @check
            api.modify_check @check, params
        else
            params[:type] = 'dns'
            api.create_check @resource[:name], params
        end
    end

    #
    # getters
    #
    def hostname
        @check.fetch('hostname', :absent)
    end

    def expectedip
        @check.fetch('expectedip', :absent)
    end

    def nameserver
        @check['type']['dns']['nameserver']
    end
end