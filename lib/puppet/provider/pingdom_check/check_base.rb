#
# Base class for all Check providers.
#
# Provider must:
# - have `:parent => :check_base` in their declaration.
# - declare any new properties as features using `has_features`.
# - create setters/getters for provider-specific properties
#   that require special handling (optional).
# - call `accessorize` at the end to create any setters/getters
#   not already defined.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'pingdom.rb'))

require 'digest'

Puppet::Type.type(:pingdom_check).provide(:check_base, :parent => Puppet::Provider::Pingdom) do

    def exists?
        if [:true, :bootstrap].include? @resource[:autofilter]
            @autotag ||= 'puppet-' + Digest::SHA1.hexdigest(@resource[:name])[0..5]
            @resource[:filter_tags] ||= []
            @resource[:filter_tags] << @autotag if @resource[:autofilter] != :bootstrap
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

    #
    # common accessors
    #
    def filter_tags=(value)
        # @property_hash[:tags] = @property_hash[:tags] + value
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
        value << @autotag if @autotag
        @property_hash[:tags] = value.join ','
    end

    def teams
        # retrieves list of ids, returns list of names
        ids = @check.fetch('teams', []).map { |i| i['id'].to_s }
        team = api.select_teams(ids, search='id') if ids
        team.map { |u| u['name'] }
    end

    def teams=(value)
        # accepts list of names, returns list of ids
        teams = api.select_teams(value, search='name')
        raise 'Unknown team in list' unless teams.size == value.size
        ids = teams.map { |u| u['id'] }
        @property_hash[:teamids] = ids
    end

    def users
        # retrieves list of ids, returns list of names
        ids = @check.fetch('userids', nil)
        user = api.select_users(ids, search='id') if ids
        if user.respond_to? :map
            user.map { |u| u['name'] }
        else
            :absent
        end
    end

    def users=(value)
        # accepts list of names, returns list of ids
        found = api.select_users(value, search='name')
        raise 'Unknown user in list' unless found.size == value.size
        ids = found.map { |u| u['id'] }
        @property_hash[:userids] = ids.join ','
    end

    accessorize :@check
end
