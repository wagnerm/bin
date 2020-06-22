#!/usr/bin/env ruby
# Just list some ec2 instances.

require 'aws-sdk-ec2'

credentials = Aws::SharedCredentials.new(profile_name: 'THE_PROFILE')
ec2 = Aws::EC2::Resource.new(region: 'THE_REGION', credentials: credentials)

ec2.instances(
  filters: [
    #{
    #  name: "instance-type",
    #  values: ["m5d.4xlarge"],
    #},
    {
      name: "tag:app",
      values: ["myapp"],
    },
  ]
).each do |i|
  app_tag = i.tags.find { |tag| tag.key == "app"}
  name_tag = i.tags.find { |tag| tag.key == "Name" }
  short_name = name_tag.value.split('.').first
  puts short_name
end
