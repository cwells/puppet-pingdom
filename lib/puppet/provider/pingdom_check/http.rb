Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check) do
    has_features :host, :port, :url, :auth, :encryption
    defaultfor :feature => :posix

    def auth
        @check.fetch('auth', :absent)
    end

    def auth=(value)
        @property_hash[:auth] = value
    end

    def encryption
        begin
            @check['type']['http']['encryption']
        rescue => exception
            :absent
        end
    end

    def encryption=(value)
        @property_hash[:encryption] = value
    end

    def host
        @check.fetch('hostname', :absent)
    end

    def host=(value)
        @property_hash[:host] = value
    end

    def port
        begin
            @check['type']['http']['port']
        rescue => exception
            :absent
        end
    end

    def port=(value)
        @property_hash[:port] = value
    end

    def url
        begin
            @check['type']['http']['url']
        rescue => exception
            :absent
        end
    end

    def url=(value)
        @property_hash[:url] = value
    end
end