require 'uri'
require 'digest'

Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check_base) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders
    defaultfor :feature => :posix

    def exists?
        if [:true, :bootstrap].include? @resource[:autofilter]
            @autotag ||= 'puppet-' + Digest::SHA1.hexdigest(@resource[:name])[0..5]
            @resource[:filter_tags] = [@autotag] if @resource[:autofilter] != :bootstrap
            @property_hash[:tags] = [@autotag]
        else
            @autotag = nil
        end

        @check ||= api.find_check @resource[:name], @resource[:filter_tags]
    end

    def create
        # Dummy method. Real work is done in `flush`.
    end

    def flush
        if @resource[:ensure] == :absent
            api.delete_check @check if @check
            return
        end

        @resource.eachproperty do |prop|
            prop = prop.to_s.to_sym
            self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end
        @property_hash[:name] = @resource[:name]

        if @check
            api.modify_check @check, @property_hash
        else
            @property_hash[:type] = @resource[:provider]
            api.create_check @property_hash
        end
    end

    def destroy
        @resource[:ensure] = :absent
    end

    def auth
        begin
            username = @check['type']['http']['username']
            password = @check['type']['http']['password']
            "#{username}:#{password}"
        rescue => exception
            :absent
        end
    end

    def encryption
        begin
            @check['type']['http']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type']['http']['port']
        rescue => exception
            :absent
        end
    end

    def postdata
        begin
            URI.decode_www_form(@check['type']['http']['postdata']).to_h
        rescue => exception
            :absent
        end
    end

    def postdata=(value)
        @property_hash[:postdata] = URI.encode_www_form(value)
    end

    def requestheaders
        begin
            headers = @check['type']['http']['requestheaders']
            headers.delete_if { |key, value| key == 'User-Agent' }
        rescue => exception
            :absent
        end
    end

    def requestheaders=(value)
        i = 0
        value.each do |k, v|
            @property_hash["requestheader#{i += 1}"] = "#{k}:#{v}"
        end
    end

    def shouldcontain
        begin
            @check['type']['http']['shouldcontain']
        rescue => exception
            :absent
        end
    end

    def shouldnotcontain
        begin
            @check['type']['http']['shouldnotcontain']
        rescue => exception
            :absent
        end
    end

    def url
        begin
            @check['type']['http']['url']
        rescue => exception
            :absent
        end
    end

    #
    # common accessors
    #
    def filter_tags=(value)
        @property_hash[:tags] = [@property_hash[:tags], value].join(',')
    end

    def host
        @check.fetch('hostname', :absent)
    end

    def paused
         @check.fetch('status', :absent) == 'paused'
    end

    def probe_filters=(value)
        newvalue = value.map { |v| 'region: ' + v }.join(',') if value.respond_to? :map
        @property_hash[:probe_filters] = newvalue
    end

    def tags
        usertags = @check.fetch('tags', []).map { |tag| tag['name'] if tag['type'] == 'u' }
        usertags.delete @autotag
        usertags
    end

    def tags=(value)
        @property_hash[:tags] = @property_hash[:tags] + value
    end

    # def teams
    #     # accepts list of ids, returns list of names
    #     ids = @check.fetch('teams', nil).map { |i| i['id'].to_s }
    #     team = api.select_teams(ids, search='id') if ids
    #     if team.respond_to? :map
    #         team.map { |u| u['name'] }
    #     else
    #         :absent
    #     end
    # end

    # def teams=(value)
    #     # accepts list of names, returns list of ids
    #     teams = api.select_teams(value, search='name')
    #     raise 'Unknown team in list' unless teams.size == value.size
    #     ids = teams.map { |u| u['id'] }
    #     @property_hash[:teamids] = ids
    # end

    def users
        # accepts list of ids, returns list of names
        # ids = @check.fetch('userids', nil)
        # user = api.select_users(ids, search='id') if ids
        # if user.respond_to? :map
        #     user.map { |u| u['name'] }
        # else
        #     :absent
        # end
        :absent
    end

    def users=(value)
        puts "USERS=#{value}"
        # accepts list of names, returns list of ids
        # found = api.select_users(value, search='name')
        # raise 'Unknown user in list' unless found.size == value.size
        # ids = found.map { |u| u['id'] }
        # puts "IDS: #{ids}"
        # @property_hash[:userids] = ids
    end

    accessorize
end