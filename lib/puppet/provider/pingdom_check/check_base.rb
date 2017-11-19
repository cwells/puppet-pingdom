# #
# # Base class for all Check providers.
# #
# # Provider must:
# # - have `:parent => :check_base` in their declaration.
# # - declare any new properties as features using `has_features`.
# # - create setters/getters for provider-specific properties
# #   that require special handling (optional).
# # - call `accessorize` at the end to create any setters/getters
# #   not already defined.
# #
# # Author: Cliff Wells <cliff.wells@protonmail.com>
# # Homepage: https://github.com/cwells/puppet-pingdom
# #

# require 'digest'

# begin # require PuppetX module
#     require File.expand_path( # yes, this is the recommended way :P
#         File.join(
#             File.dirname(__FILE__), '..', '..', '..',
#             'puppet_x', 'pingdom', 'client-2.1.rb'
#         )
#     )
#     has_pingdom_api = true
# rescue LoadError
#     has_pingdom_api = false
# end

# Puppet::Type.type(:pingdom_check).provide(:check_base) do
#     confine :true => has_pingdom_api

#     # def api
#     #     @api ||= begin
#     #         if @resource[:credentials_file]
#     #             require 'yaml'
#     #             # just let any exception bubble up
#     #             creds = YAML.load_file(
#     #                 File.expand_path @resource[:credentials_file]
#     #             )
#     #             account_email, user_email, password, appkey =
#     #                 creds['account_email'], creds['user_email'], creds['password'], creds['appkey']
#     #         else
#     #             raise 'Missing API credentials' if [
#     #                 @resource[:account_email],
#     #                 @resource[:user_email],
#     #                 @resource[:password],
#     #                 @resource[:appkey]
#     #             ].include? nil and @resource[:credentials_file].nil?
#     #             account_email, user_email, password, appkey =
#     #                 @resource[:account_email], @resource[:user_email], @resource[:password], @resource[:appkey]
#     #         end
#     #         PuppetX::Pingdom::Client.new(account_email, user_email, password, appkey, @resource[:log_level])
#     #     end
#     # end

#     # def exists?
#     #     if [:true, :bootstrap].include? @resource[:autofilter]
#     #         @autotag ||= 'puppet-' + Digest::SHA1.hexdigest(@resource[:name])[0..5]
#     #         @resource[:filter_tags] = [@autotag] if @resource[:autofilter] != :bootstrap
#     #         @property_hash[:tags] = [@autotag]
#     #     else
#     #         @autotag = nil
#     #     end

#     #     @check ||= api.find_check @resource[:name], @resource[:filter_tags]
#     # end

#     # def create
#     #     # Dummy method. Real work is done in `flush`.
#     # end

#     # def flush
#     #     if @resource[:ensure] == :absent
#     #         api.delete_check @check if @check
#     #         return
#     #     end

#     #     @resource.eachproperty do |prop|
#     #         prop = prop.to_s.to_sym
#     #         self.method("#{prop}=").call @resource[prop] if prop != :ensure
#     #     end
#     #     @property_hash[:name] = @resource[:name]

#     #     if @check
#     #         api.modify_check @check, @property_hash
#     #     else
#     #         @property_hash[:type] = @resource[:provider]
#     #         api.create_check @property_hash
#     #     end
#     # end

#     # def destroy
#     #     @resource[:ensure] = :absent
#     # end

#     #
#     # custom getters/setters
#     #

#     #
#     # utility methods
#     #
#     def self.accessorize
#         # Provides automatic creation of missing getters/setters (accessors).
#         #
#         # Similar to mk_resource_methods, but doesn't clobber existing methods, thank you.
#         # This allows us to have special cases explicitly defined, while still benefitting
#         # from accessor auto-creation (which this class method provides).
#         # Should be called at the end of every provider definition (unless you explicitly
#         # define every single getter/setter).

#         [ resource_type.validproperties, resource_type.parameters ].flatten.each do |prop|
#             # It should be noted that this loops over all properties for all check providers.
#             # This is unfortunate, but we are protected against invalid properties by the
#             # `required_features` defined on each property in the type declarations.
#             prop = prop.to_sym
#             next if prop == :name

#             if !method_defined?(prop)
#                 define_method(prop) do
#                     @check.fetch(prop.to_s, :absent)
#                 end
#             end

#             setter = "#{prop}=".to_sym
#             if !method_defined?(setter)
#                 define_method(setter) do |value|
#                     @property_hash[prop] = value
#                 end
#             end
#         end
#     end
# end
