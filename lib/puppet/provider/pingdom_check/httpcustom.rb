Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :host, :port, :url, :auth, :encryption, :additionalurls

    def additionalurls
        begin
            @check['type']['httpcustom']['additionalurls']
        rescue => exception
            :absent
        end
        @check.fetch('additionalurls', :absent)
    end

    update_resource_methods
end