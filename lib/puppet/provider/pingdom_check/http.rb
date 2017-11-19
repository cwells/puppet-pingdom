require 'uri'
require 'digest'

# require File.expand_path(File.join(File.dirname(__FILE__), 'check_base.rb'))

Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check_base) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders
    defaultfor :feature => :posix

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
    # common
    #
    # def filter_tags=(value)
    #     @property_hash[:tags] = [@property_hash[:tags], value].join(',')
    # end

    # def host
    #     @check.fetch('hostname', :absent)
    # end

    # def paused
    #      @check.fetch('status', :absent) == 'paused'
    # end

    # def probe_filters=(value)
    #     newvalue = value.map { |v| 'region: ' + v }.join(',') if value.respond_to? :map
    #     @property_hash[:probe_filters] = newvalue
    # end

    # def tags
    #     usertags = @check.fetch('tags', []).map { |tag| tag['name'] if tag['type'] == 'u' }
    #     usertags.delete @autotag
    #     usertags
    # end

    # def tags=(value)
    #     @property_hash[:tags] = @property_hash[:tags] + value
    # end

    # def users
    #     # accepts list of ids, returns list of names
    #     ids = @check.fetch('userids', nil)
    #     user = api.select_users(ids, search='id') if ids
    #     if user.respond_to? :map
    #         user.map { |u| u['name'] }
    #     else
    #         :absent
    #     end
    # end

    # def users=(value)
    #     # accepts list of names, returns list of ids
    #     found = api.select_users(value, search='name')
    #     raise 'Unknown user in list' unless found.size == value.size
    #     ids = found.map { |u| u['id'] }
    #     @property_hash[:userids] = ids
    # end


    accessorize
end