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

class PuppetX::Pingdom::Client
    @@api_host = 'https://api.pingdom.com'
    @@api_base = '/api/2.1'
    @@endpoint = {
        :checks  => "#{@@api_base}/checks",
        :teams   => "#{@@api_base}/teams",
        :users   => "#{@@api_base}/users"
    }

    def initialize(username, password, appkey, logging=nil)
        @api = if logging.nil?
            Faraday.new(:url => @@api_host)
        else
            require 'logger'
            logger = Logger.new $stderr
            logger.level = Logger.const_get(logging)

            Faraday.new(:url => @@api_host) do |faraday|
                faraday.response :logger, logger, { :bodies => true }
                faraday.request  :url_encoded
                faraday.adapter Faraday.default_adapter
            end
        end
        @api.basic_auth(username, password)
        @api.headers['App-Key'] = appkey
    end

    #
    # Checks API
    #
    def checks(filter_tags=[])
        # list of checks
        @checks ||= begin
            params = { :include_tags => true, :tags => filter_tags.join(',') }
            response = @api.get @@endpoint[:checks], params
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['checks']
        end
    end

    def get_check_details(check)
        response = @api.get "#{@@endpoint[:checks]}/#{check['id']}"
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['check']
    end

    def create_check(params)
        params.update :tags => params[:tags].join(',')
        response = @api.post @@endpoint[:checks], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['check']
    end

    def find_check(name, filter_tags)
        # returns check or nil
        check = checks(filter_tags).select { |check| check['name'] == name } [0]
        get_check_details(check) if check
    end

    def modify_check(check, params)
        params.update :tags => params[:tags].join(',')
        response = @api.put "#{@@endpoint[:checks]}/#{check['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_check(check)
        response = @api.delete @@endpoint[:checks], {
            :delcheckids => check['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    #
    # Teams API
    #
    def teams
        # list of teams
        @teams ||= begin
            response = @api.get @@endpoint[:teams]
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['teams']
        end
    end

    def create_team(params)
        response = @api.post @@endpoint[:teams], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['team']
    end

    def find_team(name)
        # returns team or nil
        teams.select { |team| team['name'] == name } [0]
    end

    def modify_team(team, params)
        response = @api.put "#{@@endpoint[:teams]}/#{team['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_team(team)
        response = @api.delete @@endpoint[:teams], {
            :delteamids => team['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    #
    # Users API
    #
    def users
        # list of users
        @users ||= begin
            response = @api.get @@endpoint[:users]
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['users']
        end
    end

    def create_user(params)
        response = @api.post @@endpoint[:users], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['user']
    end

    def find_user(name)
        # returns user or nil
        users.select { |user| user['name'] == name } [0]
    end

    def modify_user(user, params)
        response = @api.put "#{@@endpoint[:users]}/#{user['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_user(user)
        response = @api.delete @@endpoint[:users], {
            :deluserids => user['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end
end
