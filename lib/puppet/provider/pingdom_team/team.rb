require File.expand_path(File.join(File.dirname(__FILE__), '.', 'team_base.rb'))

Puppet::Type.type(:pingdom_team).provide(:team, :parent => :team_base) do
    accessorize
end