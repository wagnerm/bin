#!/usr/bin/env ruby
# List IP ranges from Azure IP range list in a specific region.

require "json"

REGIONS = [
  "AzureCloud.EastUS",
  "AzureCloud.EastUS2",
  "AzureCloud.WestUS2",
  "AzureCloud.CentralUS",
  "AzureCloud.SouthCentralUS",
]

def parse(ip_json)
  ip_ranges = []
  raw = JSON.parse File.read(ip_json)

  raw["values"].each do |v|
    if REGIONS.include? v["name"]
      ip_ranges += v["properties"]["addressPrefixes"]
    end
  end

  ip_ranges
end

ip_json = ARGV[0]
if ip_json.nil?
  puts "Usage: azure_ip_ranges.rb <azure ip json>"
  exit 1
end

puts parse(ip_json)
