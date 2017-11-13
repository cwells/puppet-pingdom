Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check_base) do
    has_features :api_2_0, :port, :stringtosend, :stringtoexpect

    def port
        begin
            @check['type']['tcp']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type']['tcp']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    def stringtosend
        begin
            @check['type']['tcp']['stringtosend']
        rescue => exception
            :absent
        end
    end

    accessorize
end