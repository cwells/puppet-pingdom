#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

Puppet::Type.newtype(:pingdom_user) do
    @doc = 'Pingdom Users API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the user.'
    end

    newparam(:username) do
        desc 'API username [string].'
    end

    newparam(:password) do
        desc 'API password [string].'
    end

    newparam(:appkey) do
        desc 'API app key [string].'
    end

    newparam(:credentials_file) do
        desc 'YAML file containing Pingdom credentials [string]'
    end

    newparam(:logging) do
        desc 'Logging level for API requests [String (ERROR, WARN, INFO, DEBUG)]'
        newvalues(:ERROR, :WARN, :INFO, :DEBUG)
    end

    #
    # common properties
    #
    newproperty(:email) do
        desc 'User email [String].'
    end

    newproperty(:sms) do
        desc %q(List of SMS targets [List of Strings])
    end

    newproperty(:paused) do
        desc %q(Don't send alerts to this user [Boolean])
        newvalues(:true, :false)
    end
end