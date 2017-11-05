#
# Thin wrapper around Pingdom API.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

require 'json'
require 'faraday'

module PuppetX; end
module PuppetX::Pingdom; end

def filter_nils(hash)
    hash.select { |k, v| !v.nil? }
end

LEGACY_NOTIFICATION_PROPERTIES = [
    'notifyagainevery', 'notifywhenbackup', 'sendnotificationwhendown',
    'sendtoandroid', 'sendtoemail', 'sendtoiphone', 'sendtosms', 'sendtotwitter'
]

def detect_legacy_notifications(properties)
    properties.each do |prop|
        if LEGACY_NOTIFICATION_PROPERTIES.include? prop
            raise "`#{prop}` requires setting `use_legacy_notifications => true`" unless properties[:use_legacy_notifications]
            return true
        end
    end
    false
end

class PuppetX::Pingdom::Client
    @@api_host = 'https://api.pingdom.com'
    @@api_base = '/api/2.0' # 2.1 doesn't support use_legacy_notifications, and BeepManager is undocumented
    @@endpoint = {
        :checks  => "#{@@api_base}/checks",
        :teams   => "#{@@api_base}/teams",
        :users   => "#{@@api_base}/users"
    }

    def initialize(username, password, appkey)
        @conn = Faraday.new(:url => @@api_host)
        @conn.basic_auth(username, password)
        @conn.headers['App-Key'] = appkey
    end

    #
    # checks API
    #
    def checks
        # list of checks
        @checks ||= begin
            response = @conn.get @@endpoint[:checks], { :include_tags => true }
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['checks']
        end
    end

    def get_check_details(check)
        response = @conn.get "#{@@endpoint[:checks]}/#{check['id']}"
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        puts "Debug(#{__method__}): #{body['check']}"
        body['check']
    end

    def create_check(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceChecks for params
        params = filter_nils params
        detect_legacy_notifications params
        puts "Debug(#{__method__}): #{params}"
        response = @conn.post @@endpoint[:checks], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['check']
    end

    def find_check(name)
        # returns check or nil
        check = checks.select { |check| check['name'] == name } [0]
        get_check_details(check) if check
    end

    def modify_check(check, params)
        params = filter_nils params
        detect_legacy_notifications params
        puts "Debug(#{__method__}): #{params}"
        response = @conn.put "#{@@endpoint[:checks]}/#{check['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        find_check check['name']
    end

    def delete_check(check)
        response = @conn.delete @@endpoint[:checks], {
            :delcheckids => check['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    #
    # teams API (UNTESTED)
    #
    def teams
        # list of teams
        @teams ||= begin response = @conn.get @@endpoint[:teams]
            body = JSON.parse(response.body)
            raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
            body['teams']
        end
    end

    def create_team(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceTeam for params
        defaults = {
            :name => name
        }
        defaults.update(params)
        response = @conn.post @@endpoint[:teams], defaults
        body = JSON.parse(response.body)
        raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
        body['team']
    end

    def find_team(name)
        # returns team or nil
        teams.select { |team| team['name'] == name } [0]
    end

    def modify_team(team, params)
        response = @conn.put "#{@@endpoint[:teams]}/#{team['id']}", params
        body = JSON.parse(response.body)
        raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
        body
    end

    def delete_team(team)
        response = @conn.delete @@endpoint[:teams], {
            :delteamids => team['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
        body
    end

    #
    # users API (UNTESTED)
    #
    def users
        # list of users
        @users ||= begin
            response = @conn.get @@endpoint[:users]
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']}" unless response.success?
            body['users']
        end
    end

    def create_user(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceUsers for params
        defaults = {
            :name => name
        }
        defaults.update(params)
        response = @conn.post @@endpoint[:users], defaults
        body = JSON.parse(response.body)
        raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
        body['user']
    end

    def find_user(name)
        # returns user or nil
        users.select { |user| user['name'] == name } [0]
    end

    def modify_user(user, params)
        response = @conn.put "#{@@endpoint[:users]}/#{user['id']}", params
        body = JSON.parse(response.body)
        raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
        body
    end

    def delete_user(user)
        response = @conn.delete @@endpoint[:users], {
            :deluserids => user['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "#{__method__}: #{body['error']['errormessage']}" unless response.success?
        body
    end
end
