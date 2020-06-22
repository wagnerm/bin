#!/usr/bin/env ruby

#
# Get a list of nodes at http://jenkins.your.site/computer/api/json?tree=computer[displayName]
#

require 'json'

filename = ARGV[0]
content = File.read(filename)

parsed = JSON.parse(content)
computers = parsed['computer'].map do |computer|
  computer['displayName']
end

nodes = []

nodes.each { |node| puts "#{node}: #{computers.include? node}" }
